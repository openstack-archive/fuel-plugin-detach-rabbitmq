notice('MODULAR: detach-rabbitmq/rabbitmq_hiera_override.pp')

$plugin_name = 'detach-rabbitmq'
$detach_rabbitmq_plugin = hiera($plugin_name, undef)

if ($detach_rabbitmq_plugin) {
  $hiera_plugins_dir = '/etc/hiera/plugins'
  $plugin_yaml = "${hiera_plugins_dir}/${plugin_name}.yaml"
  $network_metadata = hiera_hash('network_metadata')
  $rabbitmq_roles = [ 'standalone-rabbitmq' ]
  $rabbit_nodes = get_nodes_hash_by_roles($network_metadata, $rabbitmq_roles)

  $rabbit_address_map = get_node_to_ipaddr_map_by_network_role(
    $rabbit_nodes,
    'mgmt/messaging',
  )

  $rabbit_nodes_ips = values($rabbit_address_map)
  $rabbit_nodes_names = keys($rabbit_address_map)

  $amqp_hosts = $rabbit_nodes_ips
  $amqp_port = hiera('amqp_port', '5673')

  case hiera_array('roles', 'none') {
    /rabbitmq/: {
      $rabbit_enabled = true
      $corosync_roles = $rabbitmq_roles
      $deploy_vrouter = false
      # Set to true HA
      $corosync_nodes = $rabbit_nodes
    }
    default: {
      $rabbit_enabled = false
    }
  }

  $calculated_content = inline_template('<%
require "yaml"
amqp_hosts = @amqp_hosts.map {|x| x + ":" + @amqp_port}.join(",")
data = {
  "amqp_hosts" => amqp_hosts,
  "rabbit_hash" => {
    "enabled" => @rabbit_enabled,
  },
  "deploy_vrouter" => @deploy_vrouter,
}
data["corosync_nodes"] = @corosync_nodes if @corosync_nodes
data["corosync_roles"] = @corosync_roles if @corosync_roles
-%>
<%= YAML.dump(data) %>')

  file { 'hiera_plugins' :
    ensure => 'directory',
    path   => $hiera_plugins_dir,
  }

  file { 'plugin_yaml' :
    ensure  => 'present',
    path    => $plugin_yaml,
    content => $calculated_content,
  }

}

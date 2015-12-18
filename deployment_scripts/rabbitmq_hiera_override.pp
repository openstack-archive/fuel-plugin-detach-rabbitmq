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

  $amqp_port = hiera('amqp_port', '5673')
  $rabbit_nodes_ips = values($rabbit_address_map)
  $rabbit_nodes_names = keys($rabbit_address_map)

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

  $amqp_nodes = $rabbit_nodes_ips
  $amqp_hosts = inline_template("<%= @amqp_nodes.map {|x| x + ':' + @amqp_port}.join ',' %>")

  $calculated_content = inline_template('
amqp_hosts: <%= @amqp_hosts %>
rabbit_hash:
  enabled: <%= @rabbit_enabled %>
<% if @corosync_nodes -%>
<% require "yaml" -%>
corosync_nodes:
<%= YAML.dump(@corosync_nodes).sub(/--- *$/,"") %>
<% end -%>
<% if @corosync_roles -%>
corosync_roles:
<%
@corosync_roles.each do |crole|
%>  - <%= crole %>
<% end -%>
<% end -%>
deploy_vrouter: <%= @deploy_vrouter %>

  ')

  file { 'plugin_yaml' :
    ensure  => 'present',
    path    => $plugin_yaml,
    content => $calculated_content,
  }

}

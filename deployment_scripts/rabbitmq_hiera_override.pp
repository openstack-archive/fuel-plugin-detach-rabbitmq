notice('MODULAR: detach-rabbitmq/rabbitmq_hiera_override.pp')

$detach_rabbitmq_plugin = hiera('detach-rabbitmq', undef)
$hiera_dir = '/etc/hiera/override'
$plugin_name = 'detach-rabbitmq'
$plugin_yaml = "${plugin_name}.yaml"

if ($detach_rabbitmq_plugin) {
  $network_metadata = hiera_hash('network_metadata')
  $rabbitmq_roles = [ 'standalone-rabbitmq' ]
  $rabbit_nodes = get_nodes_hash_by_roles($network_metadata, $rabbitmq_roles)
#lint:ignore:80chars
  $rabbit_address_map = get_node_to_ipaddr_map_by_network_role($rabbit_nodes, 'mgmt/messaging')
#lint:endignore
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

###################
  file {'/etc/hiera/override':
    ensure  => directory,
  } ->
  file { "${hiera_dir}/${plugin_yaml}":
    ensure  => file,
    content => "${calculated_content}\n",
  }

  package {'ruby-deep-merge':
    ensure  => 'installed',
  }

  # hiera file changes between 7.0 and 8.0 so we need to handle the override the
  # different yaml formats via these exec hacks.  It should be noted that the
  # fuel hiera task will wipe out these this update to the hiera.yaml
  exec { "${plugin_name}_hiera_override_7.0":
    command => "sed -i '/  - override\/plugins/a\  - override\/${plugin_name}' /etc/hiera.yaml",
    path    => '/bin:/usr/bin',
    unless  => "grep -q '^  - override/${plugin_name}' /etc/hiera.yaml",
    onlyif  => 'grep -q "^  - override/plugins" /etc/hiera.yaml'
  }

  exec { "${plugin_name}_hiera_override_8.0":
    command => "sed -i '/    - override\/plugins/a\    - override\/${plugin_name}' /etc/hiera.yaml",
    path    => '/bin:/usr/bin',
    unless  => "grep -q '^    - override/${plugin_name}' /etc/hiera.yaml",
    onlyif  => 'grep -q "^    - override/plugins" /etc/hiera.yaml'
  }
}

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
  $yaml_additional_config = pick($detach_rabbitmq_plugin['yaml_additional_config'], {})
#lint:endignore
  $amqp_port = hiera('amqp_port', '5673')
  $rabbit_nodes_ips = values($rabbit_address_map)
  $rabbit_nodes_names = keys($rabbit_address_map)
  $settings_hash = parseyaml($yaml_additional_config)

  case hiera('role', 'none') {
    /rabbitmq/: {
      $rabbit_enabled = true
      $corosync_roles = $rabbitmq_roles 
      $deploy_vrouter = false
      # Set to true HA
      $corosync_nodes = $rabbit_nodes
    }
    /controller/: {
      $rabbit_enabled = false
    }
    default: {
      $rabbit_enabled = true
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
    content => "${detach_rabbitmq_plugin['yaml_additional_config']}\n${calculated_content}\n",
  }

  package {'ruby-deep-merge':
    ensure  => 'installed',
  }

  file_line {"${plugin_name}_hiera_override":
    path  => '/etc/hiera.yaml',
    line  => "  - override/${plugin_name}",
    after => '  - override/module/%{calling_module}',
  }

}

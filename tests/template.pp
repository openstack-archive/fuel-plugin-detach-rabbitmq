$amqp_hosts = [ '192.168.0.1', '192.168.0.2' ]
$amqp_port = '5673'
$rabbit_enabled = true
$deploy_vrouter = false
$corosync_roles = ['standalone-rabbitmq']
$corosync_nodes = ['node1', 'node2']

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

notice($calculated_content)

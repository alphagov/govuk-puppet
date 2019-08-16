# == Define: govuk_rabbitmq::federate
#
# Creates rabbitmq federation.
#
# === Parameters
#
# [*federation_user*]
#   The RabbitMQ user we federate to.
#
# [*federation_pass*]
#   The RabbitMQ password for the user we federate to.
#
# [*upstream_servers*]
#   The upstream rabbitmq servers to federate to.
#
# [*upstream_name*]
#   Designation of the upstream rabbitmq cluster to federate to.
#
# [*federation_exchange*]
#   The exchange to federate.
#
# [*max_hops*]
#   max hops (default is 1).
#

class govuk_rabbitmq::federate (
  $federation_user,
  $federation_pass,
  $upstream_servers,
  $upstream_name,
  $federation_exchange,
  $max_hops = 1,
) {
    rabbitmq_plugin { 'rabbitmq_federation':
      ensure => present,
    }
    rabbitmq_plugin { 'rabbitmq_federation_management':
      ensure => present,
    }
    exec { 'rabbitmq parameters':
      command => "rabbitmqctl set_parameter federation-upstream ${upstream_name} '{\"uri\": [ \"amqp://${federation_user}:${federation_pass}@${upstream_servers[0]}\", \"amqp://${federation_user}:${federation_pass}@${upstream_servers[1]}\",\"amqp://${federation_user}:${federation_pass}@${upstream_servers[2]}\" ], \"max-hops\": ${max_hops}}'",
      unless  => 'rabbitmqctl list_parameters | grep -qE federation',
      path    => ['/bin','/sbin','/usr/bin','/usr/sbin'],
      require => Rabbitmq_plugin['rabbitmq_federation'],
    }
    exec { 'rabbitmq policy: federation':
      command => "rabbitmqctl set_policy --apply-to exchanges federation ${federation_exchange} '{\"federation-upstream-set\":\"all\"}'",
      unless  => 'rabbitmqctl list_policies | grep -qE federation',
      path    => ['/bin','/sbin','/usr/bin','/usr/sbin'],
      require => Exec['rabbitmq parameters'],
    }
}

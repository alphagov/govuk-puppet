# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_rabbitmq (
  $monitoring_password,
  $root_password,
) {
  $root_vhost = '/'
  $monitoring_user = 'monitoring'

  include govuk_rabbitmq::firewalls
  include govuk_rabbitmq::logging
  class { 'govuk_rabbitmq::monitoring' :
    monitoring_user     => $monitoring_user,
    monitoring_password => $monitoring_password,
  }

  if ! $::aws_migration {
    include govuk_rabbitmq::repo
  }

  include '::rabbitmq'

  rabbitmq_plugin { 'rabbitmq_stomp':
    ensure => present,
  }

  if $::aws_migration {
    staging::file { 'autocluster-0.8.0.ez':
      target => "/usr/lib/rabbitmq/lib/rabbitmq_server-${::rabbitmq_version}/plugins/autocluster-0.8.0.ez",
      source => 'https://github.com/rabbitmq/rabbitmq-autocluster/releases/download/0.8.0/autocluster-0.8.0.ez',
    }

    staging::file { 'rabbitmq_aws-0.8.0.ez':
      target => "/usr/lib/rabbitmq/lib/rabbitmq_server-${::rabbitmq_version}/plugins/rabbitmq_aws-0.8.0.ez",
      source => 'https://github.com/rabbitmq/rabbitmq-autocluster/releases/download/0.8.0/rabbitmq_aws-0.8.0.ez',
    }

    rabbitmq_plugin { 'autocluster':
      ensure => present,
    }
  }

  rabbitmq_user { 'root':
    admin    => true,
    password => $root_password,
  }
  rabbitmq_user_permissions { 'root@/':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_user { $monitoring_user:
    admin    => false,
    tags     => [ 'monitoring' ],
    password => $monitoring_password,
  }

  rabbitmq_user_permissions { "${monitoring_user}@${root_vhost}":
    read_permission => '.*',
  }

  # Mark all queues on the / vhost as durable and syncronise them
  # across all nodes in the cluster.
  #
  # TODO: Once this has been released officially we can use the
  # `config_mirrored_queues` key to handle this. See:
  # https://github.com/puppetlabs/puppetlabs-rabbitmq/pull/171
  $ha_name = 'ha-all'
  $pattern = '.*'
  $definition = '{"ha-mode":"all","ha-sync-mode":"automatic"}'
  exec { "rabbitmq policy: ${ha_name}":
    command => "rabbitmqctl set_policy -p ${root_vhost} '${ha_name}' '${pattern}' '${definition}'",
    unless  => "rabbitmqctl list_policies | grep -qE '^${root_vhost}\\s+${ha_name}\\s+${pattern}\\s+${definition}\\s+0$'",
    path    => ['/bin','/sbin','/usr/bin','/usr/sbin'],
    require => Class['rabbitmq::service'],
    before  => Anchor['rabbitmq::end'],
  }

  class { 'collectd::plugin::rabbitmq':
    monitoring_password => $monitoring_password,
  }
}

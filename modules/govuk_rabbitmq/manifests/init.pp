class govuk_rabbitmq (
  $monitoring_password
  ) {
  include govuk_rabbitmq::firewalls
  include govuk_rabbitmq::logging
  include govuk_rabbitmq::monitoring
  include govuk_rabbitmq::repo
  include '::rabbitmq'

  rabbitmq_plugin { 'rabbitmq_stomp':
    ensure => present,
  }

  # FIXME: Consider using a normal user with a "monitoring" user tag.  Not
  # configurable from puppet using the current puppetlabs/rabbitmq (4.0).
  # Added here: https://github.com/puppetlabs/puppetlabs-rabbitmq/pull/193
  rabbitmq_user {'monitoring':
    admin    => true,
    password => $monitoring_password
  }

  class { 'collectd::plugin::rabbitmq':
    monitoring_password => $monitoring_password
  }
}

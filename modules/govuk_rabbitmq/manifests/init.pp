class govuk_rabbitmq {
  include govuk_rabbitmq::firewalls
  include govuk_rabbitmq::logging
  include govuk_rabbitmq::monitoring
  include '::rabbitmq'

  rabbitmq_plugin { 'rabbitmq_stomp':
    ensure => present,
  }

  class { 'collectd::plugin::rabbitmq': }
}

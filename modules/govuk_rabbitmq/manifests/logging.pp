# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_rabbitmq::logging {
  @filebeat::prospector { 'rabbitmq_startup':
    paths  => ['/var/log/rabbitmq/startup_error','/var/log/rabbitmq/startup_log'],
    fields => {'application' => 'rabbitmq'},
  }

  @filebeat::prospector { 'rabbitmq_shutdown':
    paths  => ['/var/log/rabbitmq/shutdown_error','/var/log/rabbitmq/shutdown_log'],
    fields => {'application' => 'rabbitmq'},
  }

  @filebeat::prospector { 'rabbitmq_host_log':
    paths  => ["/var/log/rabbitmq/rabbit@${::hostname}.log"],
    fields => {'application' => 'rabbitmq'},
  }
}

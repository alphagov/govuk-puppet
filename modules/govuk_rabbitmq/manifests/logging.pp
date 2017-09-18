# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_rabbitmq::logging {
  govuk_logging::logstream { 'rabbitmq_startup_log':
    logfile => '/var/log/rabbitmq/startup_log',
    fields  => {'application' => 'rabbitmq'},
  }

  govuk_logging::logstream { 'rabbitmq_startup_error':
    logfile => '/var/log/rabbitmq/startup_error',
    fields  => {'application' => 'rabbitmq'},
  }

  @filebeat::prospector { 'rabbitmq_startup':
    paths  => ['/var/log/rabbitmq/startup_error','/var/log/rabbitmq/startup_log'],
    fields => {'application' => 'rabbitmq'},
  }

  govuk_logging::logstream { 'rabbitmq_shutdown_log':
    logfile => '/var/log/rabbitmq/shutdown_log',
    fields  => {'application' => 'rabbitmq'},
  }

  govuk_logging::logstream { 'rabbitmq_shutdown_error':
    logfile => '/var/log/rabbitmq/shutdown_error',
    fields  => {'application' => 'rabbitmq'},
  }

  @filebeat::prospector { 'rabbitmq_shutdown':
    paths  => ['/var/log/rabbitmq/shutdown_error','/var/log/rabbitmq/shutdown_log'],
    fields => {'application' => 'rabbitmq'},
  }

  govuk_logging::logstream { 'rabbitmq_host_log':
    logfile => "/var/log/rabbitmq/rabbit@${::hostname}.log",
    fields  => {'application' => 'rabbitmq'},
  }

  @filebeat::prospector { 'rabbitmq_host_log':
    paths  => ["/var/log/rabbitmq/rabbit@${::hostname}.log"],
    fields => {'application' => 'rabbitmq'},
  }
}

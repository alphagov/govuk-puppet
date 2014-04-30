class govuk_rabbitmq::logging {
  govuk::logstream { 'rabbitmq_startup_log':
    logfile => '/var/log/rabbitmq/startup_log',
    fields  => {'application' => 'rabbitmq'},
  }

  govuk::logstream { 'rabbitmq_startup_error':
    logfile => '/var/log/rabbitmq/startup_error',
    fields  => {'application' => 'rabbitmq'},
  }

  govuk::logstream { 'rabbitmq_shutdown_log':
    logfile => '/var/log/rabbitmq/shutdown_log',
    fields  => {'application' => 'rabbitmq'},
  }

  govuk::logstream { 'rabbitmq_shutdown_error':
    logfile => '/var/log/rabbitmq/shutdown_error',
    fields  => {'application' => 'rabbitmq'},
  }

  govuk::logstream { 'rabbitmq_host_log':
    logfile => "/var/log/rabbitmq/rabbit@${::hostname}.log",
    fields  => {'application' => 'rabbitmq'},
  }
}

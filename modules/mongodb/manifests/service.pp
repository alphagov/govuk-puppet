class mongodb::service {

  service { 'mongodb':
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
  }

  # Log filename is also defined in mongodb::config
  govuk::logstream { 'mongodb-logstream':
    logfile => '/var/log/mongodb/mongod.log',
    fields  => {'application' => 'mongodb'},
  }

}

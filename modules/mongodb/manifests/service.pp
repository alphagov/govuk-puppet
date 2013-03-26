class mongodb::service {

  $mongod_log_file = "/var/log/mongodb/mongod.log"

  service { 'mongodb':
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    require    => [
      Package['mongodb20-10gen'],
      File['/etc/mongodb.conf'],
      File[$mongod_log_file],
      File['/etc/init/mongodb.conf'],
    ],
  }

  govuk::logstream { 'mongodb-logstream':
    logfile => $mongod_log_file,
    fields  => {'application' => 'mongodb'},
    enable  => true,
  }

}

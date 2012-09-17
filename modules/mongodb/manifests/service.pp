class mongodb::service {
  service { 'mongodb':
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    require    => [
      Package['mongodb20-10gen'],
      File['/etc/mongodb.conf'],
      File['/var/log/mongodb/mongod.log'],
      File['/etc/init/mongodb.conf'],
    ],
  }
}

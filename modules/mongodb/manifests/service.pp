class mongodb::service {
  service { 'mongodb':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [
      Package['mongodb-10gen'],
      File['/etc/mongodb.conf'],
      File['/var/log/mongodb/mongod.log'],
      File['/etc/init/mongodb.conf'],
    ],
  }
}

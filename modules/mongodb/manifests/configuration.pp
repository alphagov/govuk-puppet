class mongodb::configuration ($replicaset = $govuk_platform) {
  file { '/etc/mongodb.conf':
    ensure  => present,
    content => template('mongodb/mongodb.conf'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['mongodb-10gen'],
    notify  => Service['mongodb'],
  }

  file { '/var/log/mongodb/mongod.log':
    ensure  => present,
    owner   => 'mongodb',
    group   => 'mongodb',
    require => Package['mongodb-10gen'],
    mode    => '0644',
  }

  file { '/etc/init/mongodb.conf':
    ensure  => present,
    content => template('mongodb/upstart-standalone.conf'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['mongodb-10gen'],
    notify  => Service['mongodb'],
  }
}

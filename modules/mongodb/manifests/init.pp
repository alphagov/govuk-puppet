class mongodb::server {
  include mongodb::repository
  include mongodb::package
  include mongodb::configuration
  include mongodb::service
}

class mongodb::signing_key {
  include apt
  apt::deb_key { '7F0CEB10': }
}

class mongodb::repository {
  include apt
  include mongodb::signing_key
  apt::deb_repository { '10gen':
    url     => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
    dist    => 'dist',
    repo    => '10gen',
    require => Class['mongodb::signing_key'],
  }
}

class mongodb::package {
  include mongodb::repository

  package { 'mongodb-10gen':
    ensure  => installed,
    require => Class['mongodb::repository'],
  }
}

class mongodb::configuration {
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

class mongodb::backup($members) {
  file { '/etc/cron.daily/automongodbbackup-replicaset':
    ensure  => present,
    content => template('mongodb/automongodbbackup'),
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    require => Package['mongodb-10gen'],
  }
}

class mongodb::configure_replica_set($members) {
  file { '/etc/mongodb':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/mongodb/configure-replica-set.js':
    ensure  => present,
    content => template('mongodb/configure-replica-set.js'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/mongodb'],
  }

  exec { 'configure-replica-set':
    command => "/usr/bin/mongo --host ${members[0]} /etc/mongodb/configure-replica-set.js",
    unless  => "/usr/bin/mongo --host ${members[0]} --quiet --eval 'rs.status().ok' | grep -q 1",
    require => [
      File['/etc/mongodb/configure-replica-set.js'],
      Service['mongodb'],
    ],
  }
}

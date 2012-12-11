class mysql::server::package {

  package { 'mysql-server':
    ensure  => installed,
  }

  file { '/var/lib/mysql':
    ensure  => directory,
    require => Package['mysql-server'],
    owner   => 'mysql',
    group   => 'mysql'
  }

}

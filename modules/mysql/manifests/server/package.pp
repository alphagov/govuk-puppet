class mysql::server::package {
  package { ['mysql-server','automysqlbackup']:
    ensure => installed,
  }

  file { '/var/lib/mysql/my.cnf':
    owner   => 'mysql',
    group   => 'mysql',
    source  => 'puppet:///modules/mysql/my.cnf',
    notify  => Service['mysql'],
    require => Package['mysql-server'],
  }
}
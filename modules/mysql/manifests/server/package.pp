class mysql::server::package {
  include mysql::repository
  package { ['percona-server-server-5.1','automysqlbackup']:
    ensure  => installed,
    require => Apt::Deb_repository['percona-repo']
  }

  file { '/var/lib/mysql':
    ensure  => directory,
    require => Package['percona-server-server-5.1'],
    owner   => 'mysql',
    group   => 'mysql'
  }

  file { '/var/lib/mysql/my.cnf':
    owner   => 'mysql',
    group   => 'mysql',
    source  => 'puppet:///modules/mysql/my.cnf',
    notify  => Service['mysql'],
    require => File['/var/lib/mysql'],
  }
}

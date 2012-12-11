class mysql::server::development {

  file { '/etc/mysql/conf.d/development.cnf':
    source => 'puppet:///modules/mysql/etc/mysql/conf.d/development.cnf',
    notify => Class['mysql::server::service'],
  }

}

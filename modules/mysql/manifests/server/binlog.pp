class mysql::server::binlog ($root_password) {

  class { '::mysql::server::monitoring::master':
    root_password => $root_password,
  }

  file { '/etc/mysql/conf.d/binlog.cnf':
    source => 'puppet:///modules/mysql/etc/mysql/conf.d/binlog.cnf',
    notify => Class['mysql::server::service'],
  }

}

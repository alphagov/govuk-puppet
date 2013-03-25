class mysql::server::binlog {

  include ::mysql::server::monitoring::master

  file { '/etc/mysql/conf.d/binlog.cnf':
    source => 'puppet:///modules/mysql/etc/mysql/conf.d/binlog.cnf',
    notify => Class['mysql::server::service'],
  }

}

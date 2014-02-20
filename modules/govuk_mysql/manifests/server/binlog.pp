class govuk_mysql::server::binlog {

  class { '::govuk_mysql::server::monitoring::master': }

  file { '/etc/mysql/conf.d/binlog.cnf':
    source => 'puppet:///modules/govuk_mysql/etc/mysql/conf.d/binlog.cnf',
    notify => Class['mysql::server::service'],
  }

}

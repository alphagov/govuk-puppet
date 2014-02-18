class govuk_mysql::server::binlog ($root_password) {

  class { '::govuk_mysql::server::monitoring::master':
    root_password => $root_password,
  }

  file { '/etc/mysql/conf.d/binlog.cnf':
    source => 'puppet:///modules/govuk_mysql/etc/mysql/conf.d/binlog.cnf',
    notify => Class['govuk_mysql::server::service'],
  }

}

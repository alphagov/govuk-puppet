class mysql::server::service {
  service { 'mysql':
    ensure     => running,
    status     => '/etc/init.d/mysql status | grep "mysql start"'
  }

  govuk::logstream { 'mysql-error-logs':
    logfile => '/var/log/mysql/error.log',
    tags    => ['MYSQL', 'ERROR'],
    enable  => true,
  }
}

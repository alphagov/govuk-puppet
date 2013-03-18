class mysql::server::service ( $error_log ) {
  service { 'mysql':
    ensure     => running,
    status     => '/etc/init.d/mysql status | grep "mysql start"'
  }

  govuk::logstream { 'mysql-error-logs':
    logfile => $error_log,
    tags    => ['MYSQL', 'ERROR'],
    enable  => true,
  }
}

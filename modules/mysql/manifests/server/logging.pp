class mysql::server::logging(
  $error_log
) {
  govuk::logstream { 'mysql-error-logs':
    logfile => $error_log,
    tags    => ['error'],
    fields  => {'application' => 'mysql'},
  }
  file {'/etc/logrotate.d/mysql-server':
    content => template('mysql/etc/logrotate.d/mysql-server.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }
}

class mysql::server::logging(
  $error_log
) {
  govuk::logstream { 'mysql-error-logs':
    logfile => $error_log,
    tags    => ['error'],
    fields  => {'application' => 'mysql'},
  }
}

# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_mysql::server::logging(
  $error_log,
  $slow_query_log=undef,
) {
  govuk::logstream { 'mysql-error-logs':
    logfile => $error_log,
    tags    => ['error'],
    fields  => {'application' => 'mysql'},
  }

  if $slow_query_log {
    govuk::logstream { 'mysql-slow-query-logs':
      logfile => $slow_query_log,
      tags    => ['slow-query'],
      fields  => {'application' => 'mysql'},
    }
  }

  file {'/etc/logrotate.d/mysql-server':
    content => template('govuk_mysql/etc/logrotate.d/mysql-server.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }
}

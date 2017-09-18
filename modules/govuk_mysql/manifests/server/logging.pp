# == Class: govuk_mysql::server::logging
#
# Send logs to elasticsearch and rotate them
#
# === Parameters
#
# [*error_log*]
#
#   Where mysql is logging errors to so that they can be sent to elasticsearch
#   Mandatory.
#
# [*slow_query_log*]
#
#   Where mysql is logging slow queries to so that they can be sent to elasticsearch
#   Default: undef
#
class govuk_mysql::server::logging(
  $error_log,
  $slow_query_log=undef,
) {
  govuk_logging::logstream { 'mysql-error-logs':
    logfile => $error_log,
    tags    => ['error'],
    fields  => {'application' => 'mysql'},
  }

  @filebeat::prospector { 'mysql-error-logs':
    paths  => [$error_log],
    tags   => ['error'],
    fields => {'application' => 'mysql'},
  }

  if $slow_query_log {
    govuk_logging::logstream { 'mysql-slow-query-logs':
      logfile => $slow_query_log,
      tags    => ['slow-query'],
      fields  => {'application' => 'mysql'},
    }

    @filebeat::prospector { 'mysql-slow-query-logs':
      paths  => $slow_query_log,
      tags   => ['slow-query'],
      fields => {'application' => 'mysql'},
    }
  }

  file {'/etc/logrotate.d/mysql-server':
    content => template('govuk_mysql/etc/logrotate.d/mysql-server.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }
}

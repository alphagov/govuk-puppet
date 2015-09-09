# == Class: govuk_mysql::server::monitoring::master
#
# Monitor a mysql master
#
# === Parameters
#
# [*plaintext_mysql_password*]
#   Password for a MySQL user account which our monitoring can connect as
#
class govuk_mysql::server::monitoring::master (
  $plaintext_mysql_password,
) inherits govuk_mysql::server::monitoring {
  Collectd::Plugin::Mysql['lazy_eval_workaround'] {
    master => true,
  }

  govuk_mysql::user { 'nagios@localhost':
    password_hash => mysql_password($plaintext_mysql_password),
    table         => '*.*',
    privileges    => ['REPLICATION CLIENT'],
  }
}

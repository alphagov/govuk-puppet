# == Class: govuk_mysql::client
#
# Installs packages for both the client binaries and development
# libraries/headers. The latter of which are for compiling other clients
# against MySQL, e.g. Ruby's `mysql2` gem.
#
# It is assumed that you will always want both. They both pull in
# `mysql-common`. It is often useful to have the `mysql(1)` client to
# quickly test connectivity or queries, for example.
#
class govuk_mysql::client {
  package { ['mysql-client','libmysqlclient-dev']:
    ensure => installed,
  }
}

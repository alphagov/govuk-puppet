# == Class: govuk_mysql::libdev
#
# Install MySQL library and header files. Used by e.g. the `mysql2` RubyGem
# to build and link against.
#
class govuk_mysql::libdev {
  package { 'libmysqlclient-dev':
    ensure => present,
  }
}

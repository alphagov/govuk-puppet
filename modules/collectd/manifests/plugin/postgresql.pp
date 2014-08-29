# == Class: collectd::plugin::postgresql
#
# Monitor a PostgreSQL server.
#
# This is a class to load the collectd plugin - to monitor a specific database
# use collectd::plugin::postgresql_db
#
class collectd::plugin::postgresql {
  $user = 'collectd'
  $password = 'collectd'

  @collectd::plugin { 'postgresql':
    prefix  => '00-',
    content => template('collectd/etc/collectd/conf.d/postgresql.conf.erb'),
  }

  @postgresql::server::role { $user:
    password_hash => postgresql_password($user, $password),
    tag           => 'govuk_postgresql::server::not_slave',
  }
}

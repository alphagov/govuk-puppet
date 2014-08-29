# == Define: collectd::plugin::postgresql
#
# Monitor a postgresql server.
#
# This is a class to load the collectd plugin - to monitor a specific database
# use collectd::plugin::postgresql_db
class collectd::plugin::postgresql {
  @collectd::plugin { 'postgresql':
    prefix  => '00-',
  }
  $user = 'collectd'
  $password = 'collectd'
  @postgresql::server::role { $user:
    password_hash => postgresql_password($user, $password),
    tag           => 'govuk_postgresql::server::not_slave',
  }
}

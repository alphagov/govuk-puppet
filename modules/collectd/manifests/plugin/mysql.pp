# == Define: collectd::plugin::mysql
#
# Monitor a MySQL master, slave, or standalone server.
#
# NB: This is define() to workaround an issue in Puppet whereby param classes
# are eagerly evaluated and prevent the template from being redefined.
#
# === Parameters:
#
# [*root_password*]
#   MySQL root password.
#
# [*master*]
#   Enable `SHOW MASTER STATUS` collection.
#   Default: false
#
# [*slave*]
#   Enable `SHOW SLAVE STATUS` collection. This will disable the creation
#   of the `collectd` user, because it is expected to come from the master.
#   Default: false
#
define collectd::plugin::mysql(
  $root_password,
  $master = false,
  $slave = false
) {
  if $master and $slave {
    fail('collectd::plugin::mysql: master and slave are mutually exclusive options')
  }

  $collectd_mysql_password = 'collectd'

  if $slave != true {
    @mysql::user { 'collectd':
      root_password => $root_password,
      user_password => $collectd_mysql_password,
      remote_host   => 'localhost',
      privileges    => 'REPLICATION CLIENT',
      tag           => 'collectd::plugin',
      notify        => Collectd::Plugin['mysql'],
    }
  }

  @collectd::plugin { 'mysql':
    content => template('collectd/etc/collectd/conf.d/mysql.conf.erb'),
  }
}

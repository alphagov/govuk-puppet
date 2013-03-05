class collectd::plugin::mysql(
  $root_password
) {
  $collectd_mysql_password = 'collectd'

  @mysql::user { 'collectd':
    root_password => $root_password,
    user_password => $collectd_mysql_password,
    remote_host   => 'localhost',
    privileges    => 'REPLICATION CLIENT',
    tag           => 'collectd::plugin',
    notify        => Collectd::Plugin['mysql'],
  }

  @collectd::plugin { 'mysql':
    content => template('collectd/etc/collectd/conf.d/mysql.conf.erb'),
  }
}

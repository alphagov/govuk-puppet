# == Class: collectd::plugin::memcached
#
# Monitor a local memcached instance running on loopback (127.0.0.1).
#
# === Parameters:
#
# [*port*]
#   Port that memcached is bound to.
#   Default: 11211
#
class collectd::plugin::memcached (
  $port = 11211,
) {
  @collectd::plugin { 'memcached':
    content => template('collectd/etc/collectd/conf.d/memcached.conf.erb'),
  }
}

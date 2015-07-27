# == Class: collectd::service
#
# Makes sure that the collectd service is running.
#
class collectd::service {
  service { 'collectd':
    ensure  => running,
  }
}

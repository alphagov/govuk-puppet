# == Class: collectd::service
#
# Makes sure that the collectd service is running.
#
class collectd::service {
  service { 'collectd':
    ensure  => running,
    restart => '/etc/init.d/collectd restart || { pkill -9 collectdmon; /etc/init.d/collectd start; }',
  }
}

# == Class: collectd::service
#
# Makes sure that the collectd service is running.
#
class collectd::service {
  service { 'collectd':
    ensure  => running,
    restart => "/etc/init.d/collectd restart || { pkill -9 collectd; ps aux | grep '/usr/lib/collectd/file_handles.sh' | awk '{{print \$2}}' | xargs kill -9 ;/etc/init.d/collectd start; }",
  }
}

# == Class: collectd::service
#
# Makes sure that the collectd service is running.
#
class collectd::service {
  service { 'collectd':
    ensure  => running,
    restart => '/etc/init.d/collectd restart || { ps aux | grep collectd | awk '\{print \$2\}' | xargs kill -9 ; /etc/init.d/collectd start; }',
  }
}

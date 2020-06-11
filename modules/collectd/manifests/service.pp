# == Class: collectd::service
#
# Makes sure that the collectd service is running.
#
class collectd::service {
  service { 'collectd':
    ensure  => running,
    restart => "/etc/init.d/collectd restart || { pkill -9 collectd; ps aux | grep '/usr/lib/collectd/file_handles.sh' | awk '{{print \$2}}' | xargs kill -9 ;/etc/init.d/collectd start; }",
  }

  @@icinga::check { "check_collectd_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!collectd',
    service_description => 'collectd system statistics daemon not running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }
}

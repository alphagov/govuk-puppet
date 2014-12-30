# == Class: govuk_etcd::monitoring
#
# Monitoring checks for an etcd cluster.
#
class govuk_etcd::monitoring {

  include collectd::plugin::etcd

  @@icinga::check { "check_etcd_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!etcd',
    service_description => 'etcd not running',
    host_name           => $::fqdn,
  }
}

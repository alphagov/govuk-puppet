# == Class: govuk_containers::etcd
#
# Run the etcd daemon as a container and ensure its supporting functionality, such as
# monitoring and firewalling are correctly applied
#
class govuk_containers::etcd {

  include ::collectd::plugin::etcd

  $etcd_image = 'quay.io/coreos/etcd'
  $etcd_image_version = 'v3.1.3'

  ::docker::image { $etcd_image:
    ensure    => 'present',
    image_tag => $etcd_image_version,
    require   => Class['docker'],
  }

  ::docker::run { 'etcd':
    image   => "${etcd_image}:${etcd_image_version}",
    ports   => ['2379:2379','2380:2380'],
    require => Docker::Image[$etcd_image],
    command => 'etcd --listen-client-urls "http://0.0.0.0:2379" --advertise-client-urls "http://0.0.0.0:2379"',
  }

  ::ufw::allow { 'allow-etcd-clients-from-all':
    port => 2379,
    ip   => 'any',
  }

  @@icinga::check { "check_etcd_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!etcd',
    service_description => 'etcd running',
    host_name           => $::fqdn,
  }

}

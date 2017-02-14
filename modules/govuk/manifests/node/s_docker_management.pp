# == Class: govuk::node::s_docker_management
#
class govuk::node::s_docker_management inherits govuk::node::s_base {

  include ::docker
  include ::govuk_containers::docker_security_bench

  $etcd_image = 'quay.io/coreos/etcd'
  $etcd_image_version = 'v3.0.13'

  ::docker::image { $etcd_image:
    ensure    => 'present',
    image_tag => $etcd_image_version,
    require   => Class['docker'],
  }

  @@icinga::check { "check_dockerd_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!dockerd',
    service_description => 'dockerd running',
    host_name           => $::fqdn,
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

  include ::collectd::plugin::etcd

}

# == Class: govuk::node::s_docker_management
#
class govuk::node::s_docker_management inherits govuk::node::s_base {

  include ::docker
  include ::govuk_containers::docker_security_bench
  include ::govuk_containers::etcd

  @@icinga::check { "check_dockerd_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!dockerd',
    service_description => 'dockerd running',
    host_name           => $::fqdn,
  }

}

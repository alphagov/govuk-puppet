# == Class: govuk_docker
#
# Install and run docker
#
class govuk_docker {

  include ::docker

  @@icinga::check { "check_dockerd_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!dockerd',
    service_description => 'dockerd running',
    host_name           => $::fqdn,
    require             => Class['docker'],
  }

}

# == Class: govuk_docker
#
# Install and run docker
#
# === Parameters:
#
# [*docker_users*]
#   Specify an array of users to add to the docker group
#   Default is empty
#
# [*version*]
#   Pin a version to use
#   Default is present
#
# [*enable_collectd_plugin*]
#   Enable the collectd plugin
#   Default is true
#
class govuk_docker (
  $docker_users = [],
  $version = 'present',
  $enable_collectd_plugin = true,
){
  validate_array($docker_users)

  if $enable_collectd_plugin {
    include ::collectd::plugin::docker
  }

  include govuk_docker::repo

  class {'::docker':
    docker_users                => $docker_users,
    use_upstream_package_source => false,
    version                     => $version,
    manage_kernel               => false,
  }

  package { 'ctop':
    ensure   => 'present',
    provider => pip,
  }

  govuk_harden::sysctl::conf { 'docker-ip-forward':
    content => "net.ipv4.ip_forward = 1\n",
  }

  # Docker machines should run with the latest Xenial kernel to fix
  # stability issues
  $kernel_packages = [
    'linux-generic-lts-xenial',
    'linux-image-generic-lts-xenial',
  ]
  ensure_packages($kernel_packages)

  @@icinga::check { "check_dockerd_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!dockerd',
    service_description => 'dockerd not running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }

}

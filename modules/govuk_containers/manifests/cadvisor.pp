# == Class: govuk_containers::cadvisor
#
# Install and run a dockerised cadvisor container.
# This provides metrics and graphs for the docker
# daemon itself and other running containers.
#
# === Parameters
#
# [*image_name*]
#   Docker image name to use for the container.
#
# [*image_version*]
#   The docker image version to use.
#
class govuk_containers::cadvisor(
  $image_name = 'google/cadvisor',
  $image_version = 'v0.31.0',
) {

  ::docker::image { $image_name:
    ensure    => 'present',
    require   => Class['govuk_docker'],
    image_tag => $image_version,
  }

  ::docker::run { 'cadvisor':
    net     => 'host',
    ports   => ['8080:8080'],
    image   => $image_name,
    require => Docker::Image[$image_name],
    volumes => [
      '/:/rootfs:ro',
      '/var/run:/var/run:rw',
      '/sys:/sys:ro',
      '/var/lib/docker/:/var/lib/docker:ro',
    ],
  }

  @@icinga::check { "check_cadvisor_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!cadvisor',
    service_description => 'cadvisor running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }
}

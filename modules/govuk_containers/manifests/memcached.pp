# == Class: govuk_containers::memcached
#
# Install and run a dockerised Memcached server
#
# === Parameters
#
# [*image_name*]
#   Docker image name to use for the container.
#
# [*image_version*]
#   The docker image version to use.
#
# [*max_memory*]
#   The maximum amount of memory memcache should allocate
#
class govuk_containers::memcached(
  $image_name = 'memcached',
  $image_version = '1.4.36-alpine',
  $max_memory    = 1024
) {

  include ::collectd::plugin::memcached

  ::docker::image { $image_name:
    ensure    => 'present',
    require   => Class['govuk_docker'],
    image_tag => $image_version,
  }

  ::docker::run { 'memcached':
    net              => 'host',
    ports            => ['11211:11211'],
    image            => $image_name,
    require          => Docker::Image[$image_name],
    extra_parameters => ['-P'],
    command          => "-m ${max_memory}",
  }

  @@icinga::check { "check_memcached_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!memcached',
    service_description => 'memcached running',
    host_name           => $::fqdn,
  }
}

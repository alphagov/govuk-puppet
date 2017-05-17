# == Class: govuk_containers::redis
#
# Install and run a dockerised Redis server
#
# === Parameters
#
# [*image_name*]
#   Docker image name to use for the container.
#
# [*image_version*]
#   The docker image version to use.
#
class govuk_containers::redis(
  $image_name = 'redis',
  $image_version = '3.2.8-alpine',
) {

  # TODO: investigate why this is causing spec failiures and enable
  # include ::collectd::plugin::redis

  # store the state dumps here on the docker host
  file { '/srv/redis':
    ensure => directory,
  }

  ::docker::image { $image_name:
    ensure    => 'present',
    require   => Class['govuk_docker'],
    image_tag => $image_version,
  }

  ::docker::run { 'redis':
    net              => 'host',
    ports            => ['6379:6379'],
    image            => $image_name,
    require          => [ Docker::Image[$image_name], File['/srv/redis'] ],
    volumes          => ['/srv/redis:/data'],
    extra_parameters => ['-P'],
    command          => '--appendonly yes',
  }

  @@icinga::check { "check_redis_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!redis',
    service_description => 'redis running',
    host_name           => $::fqdn,
  }
}

# == Resource: govuk_containers::ci_redis
#
# Install and run a dockerised Redis server, intended for CI purposes
#
# === Parameters
#
# [*version*]
#   The version of the Redis Docker image to use
#
# [*port*]
#   The port that the Redis server will be exposed on
#
define govuk_containers::ci_redis(
  $ensure = 'present',
  $version = '6',
  $port = 63796
) {
  ::docker::run { $title:
    ensure => $ensure,
    ports  => ["127.0.0.1:${port}:6379"],
    image  => "redis:${version}",
  }

  @@icinga::check { "check_${title}_running_${::hostname}":
    ensure              => $ensure,
    check_command       => "check_nrpe!check_tcp!127.0.0.1 ${port}",
    service_description => "Docker Redis ${version} not accepting TCP connections",
    host_name           => $::fqdn,
  }
}

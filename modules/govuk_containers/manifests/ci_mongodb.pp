# == Resource: govuk_containers::ci_mongodb
#
# Install and run a dockerised MongoDB server, intended for CI purposes
#
# === Parameters
#
# [*version*]
#   The version of the MongoDB Docker image to use
#
# [*port*]
#   The port that the MongoDB server will be exposed on
#
define govuk_containers::ci_mongodb(
  $ensure = 'present',
  $version = '3.6',
  $port = 27036
) {
  ::docker::run { $title:
    ensure => $ensure,
    ports  => ["127.0.0.1:${port}:27017"],
    image  => "mongo:${version}",
  }

  @@icinga::check { "check_${title}_running_${::hostname}":
    ensure              => $ensure,
    check_command       => "check_nrpe!check_tcp!127.0.0.1 ${port}",
    service_description => "Docker MongoDB ${version} not accepting TCP connections",
    host_name           => $::fqdn,
  }
}

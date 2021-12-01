# == Resource: govuk_containers::ci_postgresql
#
# Install and run a dockerised PostgreSQL server, intended for CI purposes
#
# === Parameters
#
# [*version*]
#   The version of the PostgreSQL Docker image to use
#
# [*port*]
#   The port that the PostgreSQL server will be exposed on
#
define govuk_containers::ci_postgresql(
  $ensure = 'present',
  $version = '13',
  $port = 54313
) {
  ::docker::run { $title:
    ensure => $ensure,
    ports  => ["127.0.0.1:${port}:5432"],
    image  => "postgres:${version}",
    env    => ['"POSTGRES_HOST_AUTH_METHOD=trust"'],
  }

  @@icinga::check { "check_${title}_running_${::hostname}":
    ensure              => $ensure,
    check_command       => "check_nrpe!check_tcp!127.0.0.1 ${port}",
    service_description => "Docker PostgreSQL ${version} not accepting TCP connections",
    host_name           => $::fqdn,
  }
}

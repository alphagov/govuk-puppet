# == Resource: govuk_containers::ci_postgis
#
# Install and run a dockerised PostgreSQL server, intended for CI purposes
#
# === Parameters
#
# [*version*]
#   The version of PostgreSQL the PostGIS Docker image should be based on
#
# [*postgis_version*]
#   The version of PostGIS the PostGIS Docker image should be based on
#
# [*port*]
#   The port that the PostgreSQL server will be exposed on
#
define govuk_containers::ci_postgis(
  $ensure = 'present',
  $version = '14',
  $postgis_version = '3.2',
  $port = 54414
) {
  ::docker::run { $title:
    ensure => $ensure,
    ports  => ["127.0.0.1:${port}:5432"],
    image  => "postgis/postgis:${version}-${postgis_version}",
    env    => ['"POSTGRES_HOST_AUTH_METHOD=trust"'],
  }

  @@icinga::check { "check_${title}_running_${::hostname}":
    ensure              => $ensure,
    check_command       => "check_nrpe!check_tcp!127.0.0.1 ${port}",
    service_description => "Docker PostgreSQL ${version} with PostGIS ${postgis_version} not accepting TCP connections",
    host_name           => $::fqdn,
  }
}

# == Resource: govuk_containers::ci_mysql
#
# Install and run a dockerised MySQL server, intended for CI purposes
#
# === Parameters
#
# [*version*]
#   The version of the MySQL Docker image to use
#
# [*port*]
#   The port that the MySQL server will be exposed on
#
define govuk_containers::ci_mysql(
  $ensure = 'present',
  $version = '8',
  $port = 33068
) {
  ::docker::run { $title:
    ensure  => $ensure,
    ports   => ["127.0.0.1:${port}:3306"],
    image   => "mysql:${version}",
    env     => ['"MYSQL_ROOT_PASSWORD=root"'],
    command => '--default-authentication-plugin=mysql_native_password',
  }

  @@icinga::check { "check_${title}_running_${::hostname}":
    ensure              => $ensure,
    check_command       => "check_nrpe!check_tcp!127.0.0.1 ${port}",
    service_description => "Docker MySQL ${version} not accepting TCP connections",
    host_name           => $::fqdn,
  }
}

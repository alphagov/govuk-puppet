# == Define: Govuk_containers::Cluster::App
#
# A defined type that sets up healthchecks, environment variables and monitoring
# for apps running in a Docker Swarm.
#
# === Parameters:
#
# [*port*]
#   The port that configures the local healthcheck.
#
# [*ensure*]
#   Whether to ensure the frameworking for the app to exist.
#   Default: present
#
# [*envvars*]
#   An array of environment variables to start the container with.
#
# [*healthcheck_path*]
#   The path where the healthcheck for the application resides.
#
# [*json_healthcheck*]
#   Whether the healthcheck is JSON format.
#
define govuk_containers::cluster::app (
  $port,
  $ensure = 'present',
  $envvars = {},
  $healthcheck_path = undef,
  $json_healthcheck = false,
  $vhost_aliases = [],
) {
  include ::govuk_containers::cluster::global
  include ::govuk_docker
  include ::nginx

  if $ensure == 'present' {
    $ensure_dir = 'directory'
  } else {
    $ensure_dir = $ensure
  }

  $app_dir = "/etc/govuk/${title}"

  file { [$app_dir, "${app_dir}/env.d"]:
    ensure  => $ensure_dir,
    require => Class['Govuk_containers::Cluster::Global'],
  } ->

  govuk_containers::envvar { "${title}":
    directory => "${app_dir}/env.d",
    envvars   => $envvars,
    ensure    => $ensure,
  }

  validate_re($ensure, [ 'present', 'absent' ])
  validate_hash($envvars)
  validate_bool($json_healthcheck)

  $app_domain = hiera('app_domain')

  nginx::config::vhost::proxy { "${title}.${app_domain}":
    ensure  => $ensure,
    to      => ["localhost:${port}"],
    root    => '/dev/null',
    aliases => $vhost_aliases,
  }

  if $healthcheck_path {
    @@icinga::check { "check_app_${title}_up_on_${::hostname}":
      ensure              => $ensure,
      check_command       => "check_nrpe!check_app_up!${port} ${healthcheck_path}",
      service_description => "${title} app healthcheck",
      host_name           => $::fqdn,
    }
    if $json_healthcheck {
      include icinga::client::check_json_healthcheck

      $healthcheck_desc      = "${title} app health check not ok"
      $healthcheck_opsmanual = regsubst($healthcheck_desc, ' ', '-', 'G')

      @@icinga::check { "check_app_${title}_healthcheck_on_${::hostname}":
        ensure              => $ensure,
        check_command       => "check_nrpe!check_json_healthcheck!${port} ${healthcheck_path}",
        service_description => $healthcheck_desc,
        host_name           => $::fqdn,
        notes_url           => monitoring_docs_url($healthcheck_opsmanual),
      }
    }
  }

}

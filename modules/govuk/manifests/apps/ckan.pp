# == Class: govuk::apps::ckan
##
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
# [*port*]
#   What port should the app run on?
#
# [*db_hostname*]
#   The postgres instance for CKAN to connect to
#
# [*db_username*]
#   The username for the postgresql role
#
# [*db_password*]
#   The password for the postgresql role
#
# [*db_name*]
#   The database that CKAN should use
#
# [*redis_host*]
#   The Redis host that CKAN should use
#
# [*redis_port*]
#   The Redis port that CKAN should use
#
# [*secret*]
#   The secret token that CKAN uses for session encryption
#
# [*vhost_protected*]
#   Should this vhost be protected with HTTP Basic auth?
#   Default: undef
#
# [*sentry_dsn*]
#   The app-specific URL used by Sentry to report exceptions (in govuk-secrets)
#
class govuk::apps::ckan (
  $enabled                        = false,
  $port                           = '3220',
  $db_hostname                    = undef,
  $db_username                    = 'ckan',
  $db_password                    = 'foo',
  $db_name                        = 'ckan_production',
  $redis_host                     = undef,
  $redis_port                     = '6379',
  $secret                         = undef,
  $ckan_site_url                  = undef,
  $gunicorn_worker_processes      = '1',
  $priority_worker_processes      = '0',
  $bulk_worker_processes          = '0',
  $enable_harvester_fetch         = false,
  $enable_harvester_gather        = false,
  $smtp_username                  = undef,
  $smtp_password                  = undef,
  $smtp_hostname                  = undef,
  $s3_aws_access_key_id           = undef,
  $s3_aws_secret_access_key       = undef,
  $s3_bucket_name                 = undef,
  $s3_aws_region_name             = undef,
  $vhost_protected                = undef,
  $sentry_dsn                     = undef,
) {
  $ckan_home = '/var/ckan'
  $ckan_ini  = "${ckan_home}/ckan.ini"

  $request_timeout = 60

  if $enabled {
    govuk::app { 'ckan':
      app_type               => 'procfile',
      port                   => $port,
      vhost_protected        => $vhost_protected,
      vhost_ssl_only         => true,
      health_check_path      => '/healthcheck',
      log_format_is_json     => false,
      read_timeout           => $request_timeout,
      collectd_process_regex => '\/gunicorn .* \/var\/ckan\/ckan\.ini',
      nagios_memory_warning  => 2400,
      nagios_memory_critical => 2500,
      sentry_dsn             => $sentry_dsn,
      enable_nginx_vhost     => false,
    }

    $toggled_priority_ensure = $priority_worker_processes ? {
      '0'     => absent,
      default => present,
    }

    $toggled_bulk_ensure = $bulk_worker_processes ? {
      '0'     => absent,
      default => present,
    }

    $toggled_harvester_fetch = $enable_harvester_fetch ? {
      true    => present,
      default => absent,
    }

    $toggled_harvester_gather = $enable_harvester_gather ? {
      true    => present,
      default => absent,
    }

    govuk::procfile::worker { 'harvester_fetch_consumer':
      ensure         => $toggled_harvester_fetch,
      setenv_as      => 'ckan',
      enable_service => $enable_harvester_fetch,
      process_type   => 'harvester_fetch_consumer',
      respawn_count  => 15,
      process_regex  => '\/python \.\/venv\/bin\/paster --plugin=ckanext-harvest harvester fetch\_consumer',
    }

    govuk::procfile::worker { 'harvester_gather_consumer':
      ensure         => $toggled_harvester_gather,
      setenv_as      => 'ckan',
      enable_service => $enable_harvester_gather,
      process_type   => 'harvester_gather_consumer',
      process_regex  => '\/python \.\/venv\/bin\/paster --plugin=ckanext-harvest harvester gather\_consumer',
    }

    include govuk::apps::ckan::cronjobs

    Govuk::App::Envvar {
      app => 'ckan',
    }

    govuk::app::envvar {
      "${title}-CKAN_INI":
        varname => 'CKAN_INI',
        value   => $ckan_ini;
      "${title}-CKAN_HOME":
        varname => 'CKAN_HOME',
        value   => $ckan_home;
      "${title}-GUNICORN_TIMEOUT":
        varname => 'GUNICORN_TIMEOUT',
        value   => $request_timeout;
      "${title}-GUNICORN_WORKER_PROCESSES":
        varname => 'GUNICORN_WORKER_PROCESSES',
        value   => $gunicorn_worker_processes;
      "${title}-PRIORITY_WORKER_PROCESSES":
        varname => 'PRIORITY_WORKER_PROCESSES',
        value   => $priority_worker_processes;
      "${title}-BULK_WORKER_PROCESSES":
        varname => 'BULK_WORKER_PROCESSES',
        value   => $bulk_worker_processes;
    }

    govuk::app::nginx_vhost { 'ckan':
      vhost              => 'ckan',
      protected          => $vhost_protected,
      ssl_only           => true,
      app_port           => $port,
      hidden_paths       => ['/api/'],
      read_timeout       => $request_timeout,
      nginx_extra_config => template('govuk/ckan/nginx.conf.erb'),
    }

    file { $ckan_home:
      ensure => directory,
      owner  => 'deploy',
      group  => 'deploy',
    } ->

    file { $ckan_ini:
      ensure  => file,
      content => template('govuk/ckan/ckan.ini.erb'),
      owner   => 'deploy',
      group   => 'deploy',
      notify  => Service['ckan'],
    } ->

    file { "${ckan_home}/who.ini":
      ensure  => file,
      content => template('govuk/ckan/who.ini.erb'),
      owner   => 'deploy',
      group   => 'deploy',
      notify  => Service['ckan'],
    }

    file { "${ckan_home}/default":
      ensure => directory,
      owner  => 'deploy',
      group  => 'deploy',
    }
  }
}

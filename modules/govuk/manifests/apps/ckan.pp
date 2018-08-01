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
# [*db_port*]
#   The port of the database server to use in the DATABASE_URL.
#   Default: 5432
#
# [*db_allow_prepared_statements*]
#   The ?prepared_statements= parameter to use in the DATABASE_URL.
#   Default: true
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
class govuk::apps::ckan (
  $enabled                        = false,
  $port                           = '3220',
  $db_hostname                    = undef,
  $db_port                        = 5432,
  $db_allow_prepared_statements   = true,
  $db_username                    = 'ckan',
  $db_password                    = 'foo',
  $db_name                        = 'ckan_production',
  $google_analytics_access_token  = undef,
  $google_analytics_client_id     = undef,
  $google_analytics_client_secret = undef,
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
) {
  $ckan_home = '/var/ckan'
  $ckan_ini  = "${ckan_home}/ckan.ini"

  if $enabled {
    govuk::app { 'ckan':
      app_type           => 'procfile',
      port               => $port,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      log_format_is_json => false,
    }

    $toggled_priority_ensure = $priority_worker_processes ? {
      '0'     => absent,
      default => present,
    }

    $toggled_bulk_ensure = $bulk_worker_processes ? {
      '0'     => absent,
      default => present,
    }

    govuk::procfile::worker { 'celery_priority':
      ensure         => $toggled_priority_ensure,
      setenv_as      => 'ckan',
      enable_service => $priority_worker_processes != '0',
      process_type   => 'celery_priority',
      process_count  => $priority_worker_processes,
    }

    govuk::procfile::worker { 'celery_bulk':
      ensure         => $toggled_bulk_ensure,
      setenv_as      => 'ckan',
      enable_service => $bulk_worker_processes != '0',
      process_type   => 'celery_bulk',
      process_count  => $bulk_worker_processes,
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
    }

    govuk::procfile::worker { 'harvester_gather_consumer':
      ensure         => $toggled_harvester_gather,
      setenv_as      => 'ckan',
      enable_service => $enable_harvester_gather,
      process_type   => 'harvester_gather_consumer',
    }

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

    file { "${ckan_home}/google_analytics_token.json":
      ensure  => file,
      content => template('govuk/ckan/google_analytics_token.json.erb'),
      owner   => 'deploy',
      group   => 'deploy',
      notify  => Service['ckan'],
    } ->

    file { "${ckan_home}/wsgi_app.py":
      ensure  => file,
      content => template('govuk/ckan/wsgi_app.py.erb'),
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

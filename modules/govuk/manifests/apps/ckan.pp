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
# [*pycsw_port*]
#   What port should the PyCSW companion app run on?
#
# [*blanket_redirect_url*]
#   If defined, all requests will be redirected to this absolute url. Useful
#   for maintenance.
#
# [*blanket_redirect_skip_key*]
#   A request supplying this value under the header x-ckan-skip-blanket-redirect-key will
#   be allowed to skip the blanket redirect (e.g. to allow for testing).
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
# [*solr_host*]
#   The Solr host that CKAN should use
#
# [*solr_port*]
#   The Solr port that CKAN should use
#
# [*solr_core*]
#   The Solr core that CKAN should use. This will be provisioned if it doesn't
#   already exist, and if left undef, ckan will expect to use a single-core
#   Solr.
#
# [*solr_core_configset*]
#   The configset name to use when provisioning $solr_core
#
# [*secret*]
#   The secret token that CKAN uses for session encryption
#
# [*vhost_protected*]
#   Should this vhost be protected with HTTP Basic auth?
#   Default: undef
#
# [*sentry_dsn*]
#   The app-specific URL used by Sentry to report exceptions
#
class govuk::apps::ckan (
  $enabled                        = false,
  $port,
  $pycsw_port,
  $blanket_redirect_url           = undef,
  $blanket_redirect_skip_key      = undef,
  $db_hostname                    = undef,
  $db_username                    = 'ckan',
  $db_password                    = 'foo',
  $db_name                        = 'ckan_production',
  $redis_host                     = undef,
  $redis_port                     = '6379',
  $solr_host                      = '127.0.0.1',
  $solr_port                      = '8983',
  $solr_core                      = undef,
  $solr_core_configset            = undef,
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
  $pycsw_config = "${ckan_home}/pycsw.cfg"

  $ckan_ini = "${ckan_home}/ckan.ini"
  $who_ini = "${ckan_home}/who.ini"
  $govuk_ckan_ini = 'govuk/ckan/ckan.ini.erb'
  $govuk_who_ini = 'govuk/ckan/who.ini.erb'
  $collectd_process_regex = '\/gunicorn -p /var/run/ckan/unicornherder.pid'
  $fetch_process_regex = '\/ckan .* harvester fetch-consumer'
  $gather_process_regex = '\/ckan .* harvester gather-consumer'
  $pycsw_cmd = "ckan -c ${ckan_ini} ckan-pycsw"

  $request_timeout = 60

  if $enabled {
    govuk::app { 'ckan':
      app_type                           => 'procfile',
      port                               => $port,
      vhost_protected                    => $vhost_protected,
      vhost_ssl_only                     => true,
      health_check_path                  => '/healthcheck',
      log_format_is_json                 => false,
      read_timeout                       => $request_timeout,
      collectd_process_regex             => $collectd_process_regex,
      local_tcpconns_established_warning => $gunicorn_worker_processes,
      sentry_dsn                         => $sentry_dsn,
      enable_nginx_vhost                 => false,
      alert_5xx_warning_rate             => 0.02,
      alert_5xx_critical_rate            => 0.05,
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
      ensure          => $toggled_harvester_fetch,
      setenv_as       => 'ckan',
      enable_service  => $enable_harvester_fetch,
      process_type    => 'harvester_fetch_consumer',
      respawn_count   => 15,
      process_regex   => $fetch_process_regex,
      stdout_log_json => false,
    }

    govuk::procfile::worker { 'harvester_gather_consumer':
      ensure          => $toggled_harvester_gather,
      setenv_as       => 'ckan',
      enable_service  => $enable_harvester_gather,
      process_type    => 'harvester_gather_consumer',
      process_regex   => $gather_process_regex,
      stdout_log_json => false,
    }

    govuk::procfile::worker { 'pycsw_web':
      ensure          => present,
      setenv_as       => 'ckan',
      enable_service  => running,
      process_type    => 'pycsw_web',
      process_regex   => 'pycsw\.wsgi',
      stdout_log_json => false,
    }

    class { 'cronjobs':
      ckan_port    => $port,
      pycsw_config => $pycsw_config,
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
      "${title}-CKAN_PORT":
        varname => 'CKAN_PORT',
        value   => "${port}"; # lint:ignore:only_variable_string
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
      "${title}-PYCSW_PORT":
        varname => 'PYCSW_PORT',
        value   => "${pycsw_port}"; # lint:ignore:only_variable_string
      "${title}-PYCSW_CONFIG":
        varname => 'PYCSW_CONFIG',
        value   => $pycsw_config;
      "${title}-LC_ALL":
        varname => 'LC_ALL',
        value   => 'C.UTF-8';
      "${title}-LANG":
        varname => 'LANG',
        value   => 'C.UTF-8';
    }

    $app_domain = hiera('app_domain')

    govuk::app::nginx_vhost { 'ckan':
      vhost              => 'ckan',
      protected          => $vhost_protected,
      ssl_only           => true,
      app_port           => $port,
      hidden_paths       => ['/api/', '/revision'],
      read_timeout       => $request_timeout,
      nginx_extra_config => template('govuk/ckan/nginx.conf.erb'),
      deny_crawlers      => true,
      http_host          => "ckan.${app_domain}",
    }

    file { $ckan_home:
      ensure => directory,
      owner  => 'deploy',
      group  => 'deploy',
    } ->

    file { $ckan_ini:
      ensure  => file,
      content => template($govuk_ckan_ini),
      owner   => 'deploy',
      group   => 'deploy',
      notify  => Service['ckan'],
    } ->

    file { $who_ini:
      ensure  => file,
      content => template($govuk_who_ini),
      owner   => 'deploy',
      group   => 'deploy',
      notify  => Service['ckan'],
    } ->

    file { "${ckan_home}/default":
      ensure => directory,
      owner  => 'deploy',
      group  => 'deploy',
    } ->

    file { $pycsw_config:
      ensure  => file,
      content => template('govuk/ckan/pycsw.cfg.erb'),
      owner   => 'deploy',
      group   => 'deploy',
    }

    $ckan_bin = '/var/apps/ckan/venv3/bin'
    $pycsw_tables_created = "${ckan_home}/pycsw_tables_created.tmp"

    exec { 'setup_pycsw_tables':
      command => "${ckan_bin}/${pycsw_cmd} setup -p ${pycsw_config} && sudo touch ${pycsw_tables_created}",
      creates => $pycsw_tables_created,
    }

    if ($solr_core != undef) {
      govuk_solr6::core { $solr_core:
        solr_host => $solr_host,
        solr_port => $solr_port,
        configset => $solr_core_configset,
      }
    }

    file { '/etc/cron.daily/cleanup-sessions.sh':
      ensure  => present,
      content => "#!/bin/sh\nset -e\nfind /tmp/dgu/sessions -type f -mtime +6 -delete",
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
    }
  }
}

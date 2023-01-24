# == Class: govuk::deploy::config
#
# Configuration resources for apps. Changes to the contents of these will
# require an app to be restarted. For example, to pick up changes to
# environment variables or centralised unicorn options.
#
# === Parameters
#
# [*asset_root*]
#   The location that the site's assets are served from, including protocol.
#
# [*errbit_environment_name*]
#   Name of the environment to be included in Errbit error reports.
#
# [*govuk_env*]
#   GOV.UK environment
#   Default: 'production'
#
# [*govuk_environment_name*]
#   Name of the environment used to populate the environment label for
#   publishing apps.
#
# [*website_root*]
#   The location that the website is served from, including protocol.
#
# [*app_domain*]
#   The app domain for the environment eg dev.gov.uk
#
# [*csp_report_only*]
#   Whether to report content security policy violations rather than block them
#
# [*csp_report_uri*]
#   The URI to report any content security policy violations too
#
# [*nofile_limit*]
#   Limit for the number of open files for the deploy domain.
#   Default: 16384
#
# [*nproc_limit*]
#   Limit for the number of processes for the deploy domain.
#   Default: 2048
#
# [*sidekiq_logfile*]
#   Path to the logfile for Sidekiq (async work queue library).
#   Default: 'log/sidekiq.log'

class govuk::deploy::config(
  $asset_root,
  $errbit_environment_name = '',
  $govuk_env = 'production',
  $govuk_environment_name = '',
  $website_root,
  $app_domain,
  $csp_report_only = false,
  $csp_report_uri = undef,
  $nofile_limit = 16384,
  $nproc_limit = 2048,
  $sidekiq_logfile = 'log/sidekiq.log',
){

  limits::limits { 'deploy_nofile':
    ensure     => present,
    user       => 'deploy',
    limit_type => 'nofile',
    both       => $nofile_limit,
  }

  limits::limits { 'deploy_nproc':
    ensure     => present,
    user       => 'deploy',
    limit_type => 'nproc',
    both       => $nproc_limit,
  }

  file { '/etc/govuk/unicorn.rb':
    ensure  => present,
    source  => 'puppet:///modules/govuk/etc/govuk/unicorn.rb',
    require => File['/etc/govuk'],
  }

  # govuk_spinup is a wrapper script used to start up apps that form part of
  # the GOV.UK stack. It exports various environment variables used by
  # Rails/A. N. Other Application Framework, and starts up either
  # Procfile-based or unicorn applications.
  file { '/usr/local/bin/govuk_spinup':
    ensure => present,
    source => 'puppet:///modules/govuk/usr/local/bin/govuk_spinup',
    mode   => '0755',
  }

  # govuk_supervised_initctl is a wrapper script around initctl that is
  # used to confirm that new processes are started, stopped or reloaded after
  # an initctl operation is called. It is used as part of the deployment
  # process to ensure a new deploy results in at least one running process.
  file { '/usr/local/bin/govuk_supervised_initctl':
    ensure => present,
    source => 'puppet:///modules/govuk/usr/local/bin/govuk_supervised_initctl',
    mode   => '0755',
  }

  # govuk_setenv is a simple script that loads the environment for a GOV.UK
  # application and execs its arguments
  # daemontools provides envdir, used by govuk_setenv
  file { '/usr/local/bin/govuk_setenv':
    ensure  => present,
    content => template('govuk/usr/local/bin/govuk_setenv'),
    mode    => '0755',
    require => Package['daemontools'],
  }

  # /etc/govuk/env.d is an envdir. Each file and its contents should denote
  # the name and value of an environment variable that should be exported
  file { '/etc/govuk/env.d':
    ensure  => directory,
    purge   => true,
    recurse => true,
    force   => true,
    require => File['/etc/govuk'],
  }

  $csp_report_only_value = $csp_report_only ? {
    true => 'yes',
    default => undef,
  }

  govuk_envvar {
    'GOVUK_ENV': value => $govuk_env;
    'NODE_ENV': value => $govuk_env;
    'RACK_ENV':  value => $govuk_env;
    'RAILS_ENV': value => $govuk_env;

    'ERRBIT_ENVIRONMENT_NAME': value    => $errbit_environment_name;
    'SENTRY_CURRENT_ENV': value         => $errbit_environment_name;
    'GOVUK_ENVIRONMENT_NAME': value     => $govuk_environment_name;
    'GOVUK_ASSET_ROOT': value           => $asset_root;
    'GOVUK_WEBSITE_ROOT': value         => $website_root;
    'GOVUK_CSP_REPORT_ONLY': value      => $csp_report_only_value;
    'GOVUK_CSP_REPORT_URI': value       => $csp_report_uri;
    # This env var can be removed once all GOV.UK apps are using Sidekiq >= 6
    'SIDEKIQ_LOGFILE': value            => $sidekiq_logfile;
    'GOVUK_SIDEKIQ_JSON_LOGGING': value => '1';
  }

  if ($::aws_environment != 'production') {
    govuk_envvar {
      'GOVUK_DATA_SYNC_PERIOD': value => data_sync_times('time_range');
    }
  }

  $app_domain_internal = hiera('app_domain_internal')

  govuk_envvar {
    # By default traffic should route internally
    'GOVUK_APP_DOMAIN':           value => $app_domain_internal;
    'GOVUK_APP_DOMAIN_EXTERNAL':  value => $app_domain;
  }

  # 1. Signon is still in Carrenza Staging and Production.
  if ($::aws_environment == 'staging') or ($::aws_environment == 'production') {
    # draft_content_store overrides PLEK_SERVICE_SIGNON_URI itself because it
    # uses PLEK_HOSTNAME_PREFIX and therefore has to avoid prefixing the
    # signon URL with 'draft-'. We therefore mustn't override it here, otherwise
    # we're duplicating the resource.
    unless $::govuk_node_class == 'draft_content_store' {
      govuk_envvar {
        'PLEK_SERVICE_SIGNON_URI': value => "https://signon.${app_domain}";
      }
    }
  }

}

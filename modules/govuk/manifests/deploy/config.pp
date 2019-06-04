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
# [*website_root*]
#   The location that the website is served from, including protocol.
#
# [*app_domain*]
#   The app domain for the environment eg dev.gov.uk
#
# [*licensify_app_domain*]
#   The app domain for Licensify hosts, which are different in AWS.
#
# [*csp_report_only*]
#   Whether to report content security policy violations rather than block them
#
# [*csp_report_uri*]
#   The URI to report any content security policy violations too
#
class govuk::deploy::config(
  $asset_root,
  $errbit_environment_name = '',
  $govuk_env = 'production',
  $website_root,
  $app_domain,
  $licensify_app_domain = undef,
  $csp_report_only = false,
  $csp_report_uri = undef,
){

  limits::limits { 'deploy_nofile':
    ensure     => present,
    user       => 'deploy',
    limit_type => 'nofile',
    both       => 16384,
  }

  limits::limits { 'deploy_nproc':
    ensure     => present,
    user       => 'deploy',
    limit_type => 'nproc',
    both       => 2048,
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

    'ERRBIT_ENVIRONMENT_NAME': value   => $errbit_environment_name;
    'SENTRY_CURRENT_ENV': value        => $errbit_environment_name;
    'GOVUK_ASSET_HOST': value          => $asset_root;
    'GOVUK_ASSET_ROOT': value          => $asset_root;
    'GOVUK_WEBSITE_ROOT': value        => $website_root;
    'GOVUK_CSP_REPORT_ONLY': value     => $csp_report_only_value;
    'GOVUK_CSP_REPORT_URI': value      => $csp_report_uri;
  }

  if $::aws_migration {
    $app_domain_internal = hiera('app_domain_internal')

    govuk_envvar {
      # By default traffic should route internally
      'GOVUK_APP_DOMAIN':           value => $app_domain_internal;
      'GOVUK_APP_DOMAIN_EXTERNAL':  value => $app_domain;
      # We do not host Licensify in AWS, so need to redirect to
      # it's external domain
      'PLEK_SERVICE_LICENSIFY_URI': value => "https://licensify.${licensify_app_domain}";
    }
  } else {
    govuk_envvar {
      'GOVUK_APP_DOMAIN':           value => $app_domain;
      'GOVUK_APP_DOMAIN_EXTERNAL':  value => $app_domain;
    }
  }
}

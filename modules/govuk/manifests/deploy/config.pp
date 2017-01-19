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
# [*appsignal_api_key*]
#   Appsignal API key (https://appsignal.com/gov-dot-uk). For evaluation on
#   integration.
#
class govuk::deploy::config(
  $asset_root,
  $errbit_environment_name = '',
  $govuk_env = 'production',
  $website_root,
  $appsignal_api_key = undef,
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
    both       => 1024,
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

  $app_domain = hiera('app_domain')

  govuk_envvar {
    'GOVUK_ENV': value => $govuk_env;
    'NODE_ENV': value => $govuk_env;
    'RACK_ENV':  value => $govuk_env;
    'RAILS_ENV': value => $govuk_env;

    'ERRBIT_ENVIRONMENT_NAME': value   => $errbit_environment_name;
    'APPSIGNAL_API_KEY': value         => $appsignal_api_key;
    'GOVUK_APP_DOMAIN': value          => $app_domain;
    'GOVUK_ASSET_HOST': value          => $asset_root;
    'GOVUK_ASSET_ROOT': value          => $asset_root;
    'GOVUK_WEBSITE_ROOT': value        => $website_root;
  }
}

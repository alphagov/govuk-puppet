# == Class: govuk::apps::imminence
#
# Imminence manages sets of (somewhat) structured data for use
# elsewhere on GOV.UK. It's primarily used for geographical data such
# as lists of registry offices, test centres, and the like. There is a
# simple JSON API for integrating the data with other applications.
#
# === Parameters
#
# [*ensure*]
#   Whether Imminence should be present or absent.
#
# [*port*]
#   The port that Imminence is served on.
#
# [*enable_procfile_worker*]
#   Whether to enable the Procfile worker.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
#
# [*mongodb_nodes*]
#   An array of MongoDB instance hostnames
#
# [*mongodb_name*]
#   The name of the MongoDB database to use
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*redis_host*]
#   Redis host for Sidekiq.
#
# [*redis_port*]
#   Redis port for Sidekiq.
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
# [*unicorn_worker_processes*]
#   The number of unicorn worker processes to run
#   Default: undef
#
class govuk::apps::imminence(
  $ensure = 'present',
  $port,
  $enable_procfile_worker = true,
  $sentry_dsn = undef,
  $mongodb_nodes = undef,
  $mongodb_name = 'imminence_production',
  $redis_host = undef,
  $redis_port = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $secret_key_base = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $unicorn_worker_processes = undef,
  $app_domain = undef,
) {

  $app_name = 'imminence'

  Govuk::App::Envvar {
    ensure => $ensure,
    app    => $app_name,
  }

  govuk::app { $app_name:
    ensure                   => $ensure,
    app_type                 => 'rack',
    port                     => $port,
    sentry_dsn               => $sentry_dsn,
    vhost_ssl_only           => true,
    health_check_path        => '/',
    log_format_is_json       => true,
    asset_pipeline           => true,
    nagios_memory_warning    => $nagios_memory_warning,
    nagios_memory_critical   => $nagios_memory_critical,
    unicorn_worker_processes => $unicorn_worker_processes,
  }

  govuk::app::envvar {
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  if $secret_key_base {
    govuk::app::envvar {
      "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    }
  }

  if $app_domain {
    govuk::app::envvar {
      "${title}-GOVUK_APP_DOMAIN":
      varname => 'GOVUK_APP_DOMAIN',
      value   => $app_domain;
      "${title}-GOVUK_APP_DOMAIN_EXTERNAL":
      varname => 'GOVUK_APP_DOMAIN_EXTERNAL',
      value   => $app_domain;
    }
  }

  if $::govuk_node_class !~ /^development$/ {
    govuk::app::envvar::mongodb_uri { $app_name:
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }
  }

  govuk::procfile::worker { $app_name:
    ensure         => $ensure,
    enable_service => $enable_procfile_worker,
  }
}

# == Class: govuk::apps::collections
#
# Collections is an app to serve collection pages from the content store
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#   Default: collections
#
# [*port*]
#   What port should the app run on?
#
# [*unicorn_worker_processes*]
#   The number of unicorn worker processes to run
#   Default: undef
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
# [*email_alert_api_bearer_token*]
#   Bearer token for communication with the email-alert-api
#
# [*feature_flag_accounts*]
#   Feature flag to switch GOV.UK Accounts on or off for the Transition Checker
#
# [*memcache_servers*]
#   URL of a shared memcache cluster.
#
class govuk::apps::collections(
  $vhost = 'collections',
  $port,
  $unicorn_worker_processes = undef,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $email_alert_api_bearer_token = undef,
  $feature_flag_accounts = false,
  $memcache_servers = undef,
) {
  govuk::app { 'collections':
    app_type                 => 'rack',
    port                     => $port,
    unicorn_worker_processes => $unicorn_worker_processes,
    health_check_path        => '/healthcheck',
    json_health_check        => true,
    log_format_is_json       => true,
    asset_pipeline           => true,
    asset_pipeline_prefixes  => ['assets/collections'],
    vhost                    => $vhost,
    nagios_memory_warning    => $nagios_memory_warning,
    nagios_memory_critical   => $nagios_memory_critical,
    sentry_dsn               => $sentry_dsn,
  }

  Govuk::App::Envvar {
    app => 'collections',
  }

  $feature_flag_accounts_var = $feature_flag_accounts ? {
                true    => 'enabled',
                default => undef
        }

  govuk::app::envvar {
    "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
        varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
        value   => $email_alert_api_bearer_token;
    "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
    "${title}-FEATURE-FLAG-ACCOUNTS":
        varname => 'FEATURE_FLAG_ACCOUNTS',
        value   => $feature_flag_accounts_var;
    # MEMCACHE_SERVERS is used by "Dalli", our memcached client gem
    # https://github.com/petergoldstein/dalli/blob/1fbef3c/lib/dalli/client.rb#L35
    "${title}-MEMCACHE_SERVERS":
        varname => 'MEMCACHE_SERVERS',
        value   => $memcache_servers;
  }
}

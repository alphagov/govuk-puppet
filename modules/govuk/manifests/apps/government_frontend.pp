# == Class: govuk::apps::government_frontend
#
# Government Frontend is an app to serve content pages form the content store
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#   Default: 'government-frontend'
#
# [*port*]
#   What port should the app run on?
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*account_api_bearer_token*]
#   Bearer token for communication with the account-api
#   Default: undef
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*unicorn_worker_processes*]
#   The number of unicorn worker processes to run
#   Default: undef
#
# [*cpu_warning*]
#   CPU usage percentage that alerts are sounded at
#   Default: undef
#
# [*cpu_critical*]
#   CPU usage percentage that alerts are sounded at
#
class govuk::apps::government_frontend(
  $vhost = 'government-frontend',
  $port,
  $sentry_dsn = undef,
  $secret_key_base = undef,
  $account_api_bearer_token = undef,
  $publishing_api_bearer_token = undef,
  $unicorn_worker_processes = undef,
  $cpu_warning = 300,
  $cpu_critical = 300,
) {
  Govuk::App::Envvar {
    app => 'government-frontend',
  }

  govuk::app::envvar {
    "${title}-ACCOUNT_API_BEARER_TOKEN":
        varname => 'ACCOUNT_API_BEARER_TOKEN',
        value   => $account_api_bearer_token;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
    "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
  }

  govuk::app { 'government-frontend':
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    vhost_ssl_only             => true,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    asset_pipeline             => true,
    asset_pipeline_prefixes    => ['assets/government-frontend'],
    vhost                      => $vhost,
    unicorn_worker_processes   => $unicorn_worker_processes,
    cpu_warning                => $cpu_warning,
    cpu_critical               => $cpu_critical,
  }
}

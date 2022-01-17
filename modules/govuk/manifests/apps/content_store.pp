# == Class govuk::apps::content_store
#
# The central storage of published content on GOV.UK
#
# === Parameters
#
# [*port*]
#   The port the app will listen on.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*mongodb_name*]
#   The mongo database to be used. Overriden in development
#   to be 'content_store_development'.
#
# [*performance_platform_big_screen_view_url*]
#   Performance platform big screen view url
#   Default: undef
#
# [*performance_platform_spotlight_url*]
#   Performance platform spotlight url
#   Default: undef
#
# [*vhost*]
#   Virtual host for this application.
#   Default: content-store
#
# [*default_ttl*]
#   The default cache timeout in seconds.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*unicorn_worker_processes*]
#   The number of unicorn workers to run for an instance of this app
#
# [*oauth_id*]
#   The OAuth ID used by GDS-SSO to identify the app to GOV.UK Signon
#
# [*oauth_secret*]
#   The OAuth secret used by GDS-SSO to authenticate the app to GOV.UK Signon
#
# [*router_api_bearer_token*]
#   The bearer token that will be used to authenticate with the router api
#
# [*plek_service_rummager_uri*]
#   rummager URL envvar
#   Default: undef
#

class govuk::apps::content_store(
  $port,
  $mongodb_nodes,
  $mongodb_name,
  $vhost = 'content-store',
  $default_ttl = '1200',
  $performance_platform_big_screen_view_url = undef,
  $performance_platform_spotlight_url = undef,
  $publishing_api_bearer_token = undef,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $unicorn_worker_processes = undef,
  $app_domain = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $router_api_bearer_token = undef,
  $plek_service_rummager_uri = undef,
) {
  $app_name = 'content-store'

  govuk::app { $app_name:
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    vhost_ssl_only             => true,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    log_format_is_json         => true,
    vhost                      => $vhost,
    unicorn_worker_processes   => $unicorn_worker_processes,
    alert_when_threads_exceed  => 155,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => $mongodb_nodes,
    database => $mongodb_name,
  }

  if $secret_key_base {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    }
  }

  if $app_domain {
    govuk::app::envvar {
      "${title}-GOVUK_APP_DOMAIN":
      varname => 'GOVUK_APP_DOMAIN',
      value   => $app_domain;
    }
  }

  govuk::app::envvar {
    "${title}-DEFAULT_TTL":
      varname => 'DEFAULT_TTL',
      value   => $default_ttl;
    "${title}-GDS_SSO_OAUTH_ID":
      varname => 'GDS_SSO_OAUTH_ID',
      value   => $oauth_id;
    "${title}-GDS_SSO_OAUTH_SECRET":
      varname => 'GDS_SSO_OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-ROUTER_API_BEARER_TOKEN":
        varname => 'ROUTER_API_BEARER_TOKEN',
        value   => $router_api_bearer_token;
    "${title}-PERFORMANCEPLATFORM_BIG_SCREEN_VIEW":
      varname => 'PLEK_SERVICE_PERFORMANCEPLATFORM_BIG_SCREEN_VIEW_URI',
      value   => $performance_platform_big_screen_view_url;
    "${title}-PERFORMANCEPLATFORM_SPOTLIGHT":
      varname => 'PLEK_SERVICE_SPOTLIGHT_URI',
      value   => $performance_platform_spotlight_url;
    "${title}-RUMMAGER_URI":
      varname => 'PLEK_SERVICE_RUMMAGER_URI',
      value   => $plek_service_rummager_uri;
  }
}

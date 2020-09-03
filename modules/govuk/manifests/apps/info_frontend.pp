# == Class: govuk::apps::info_frontend
#
# === Parameters
#
# [*port*]
#   The port that the app is served on.
#
# [*enabled*]
#   Whether the app should be present in a given environment.
#   Default: true
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*vhost_aliases*]
#   An array of aliases to pass to NGINX.
#
class govuk::apps::info_frontend(
  $port,
  $enabled = false,
  $secret_key_base = undef,
  $publishing_api_bearer_token = undef,
  $sentry_dsn = undef,
  $vhost_aliases = [],
) {
  $app_name = 'info-frontend'

  govuk::app { $app_name:
    app_type                => 'rack',
    port                    => $port,
    sentry_dsn              => $sentry_dsn,
    vhost_aliases           => $vhost_aliases,
    log_format_is_json      => true,
    asset_pipeline          => true,
    asset_pipeline_prefixes => ['assets/info-frontend'],
    health_check_path       => '/healthcheck',
    json_health_check       => true,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
  }
}

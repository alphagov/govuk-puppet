# == Class: govuk::apps::calendars
#
# Serves calendars in a clear and accessible format, along with JSON and iCal
# exports of the data.
#
# === Parameters
#
# [*port*]
#   The port that Calendars is served on.
#   Default: 3011
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
#
class govuk::apps::calendars(
  $port = '3011',
  $sentry_dsn = undef,
  $secret_key_base = undef,
  $publishing_api_bearer_token = undef,
) {
  $app_name = 'calendars'

  govuk::app { $app_name:
    app_type              => 'rack',
    port                  => $port,
    sentry_dsn            => $sentry_dsn,
    health_check_path     => '/bank-holidays',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'calendars',
    frame_options         => 'sameorigin',
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
  }

  if $secret_key_base {
    govuk::app::envvar {
      "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
    }
  }
}

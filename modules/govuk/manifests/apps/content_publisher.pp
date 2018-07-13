# == Class: govuk::apps::content-publisher
#
# Read more: https://github.com/alphagov/content-publisher
#
# === Parameters
# [*port*]
#   What port should the app run on? Find the next free one in development-vm/Procfile
#
# [*enabled*]
#   Whether to install the app. Don't change the default (false) until production-ready
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions (in govuk-secrets)
#
# [*sentry_dsn*]
#   The app-specific URL used by Sentry to report exceptions (in govuk-secrets)
#
# [*oauth_id*]
#   The OAuth ID used to identify the app to GOV.UK Signon (in govuk-secrets)
#
# [*oauth_secret*]
#   The OAuth secret used to authenticate the app to GOV.UK Signon (in govuk-secrets)
#
class govuk::apps::content_publisher (
  $port = '3221',
  $enabled = false,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $oauth_id = undef,
  $oauth_secret = undef
) {
  $app_name = 'content-publisher'

  $ensure = $enabled ? {
    true  => 'present',
    false => 'absent',
  }

  # see modules/govuk/manifests/app.pp for more options
  govuk::app { $app_name:
    ensure            => $ensure,
    app_type          => 'rack',
    port              => $port,
    sentry_dsn        => $sentry_dsn,
    vhost_ssl_only    => true,
    health_check_path => '/healthcheck', # must return HTTP 200 for an unauthenticated request
    deny_framing      => true,
    asset_pipeline    => true,
  }

  Govuk::App::Envvar {
    app               => $app_name,
    ensure            => $ensure,
    notify_service    => $enabled,
  }

  govuk::app::envvar {
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
  }
}

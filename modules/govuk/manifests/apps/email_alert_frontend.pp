# == Class: govuk::apps::email_alert_frontend
#
# This is a Rails frontend application allowing the general public to subscribe
# to email alerts.
#
# Signup pages are created by publishing to the content store, and then rendered
# by this application.
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#   Default: 'email-alert-frontend'
#
# [*port*]
#   What port should the app run on?
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
class govuk::apps::email_alert_frontend(
  $vhost = 'email-alert-frontend',
  $port = '3099',
  $errbit_api_key = undef,
  $secret_key_base = undef,
  $sentry_dsn = undef,
) {
  govuk::app { 'email-alert-frontend':
    app_type              => 'rack',
    port                  => $port,
    sentry_dsn            => $sentry_dsn,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'email-alert-frontend',
    vhost                 => $vhost,
  }

  Govuk::App::Envvar {
    app => 'email-alert-frontend',
  }

  govuk::app::envvar {
    "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
    "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
  }
}

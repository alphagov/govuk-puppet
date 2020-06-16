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
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*email_alert_api_bearer_token*]
#   Bearer token for communication with the email-alert-api
#
# [*email_alert_auth_token*]
#   Sets the secret token used for encrypting and decrypting messages shared
#   between email alert applications
#
# [*subscription_management_enabled*]
#   Whether the subscription management interface is enabled.
#
class govuk::apps::email_alert_frontend(
  $vhost = 'email-alert-frontend',
  $port,
  $publishing_api_bearer_token = undef,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $email_alert_api_bearer_token = undef,
  $email_alert_auth_token = undef,
  $subscription_management_enabled = false,
) {
  govuk::app { 'email-alert-frontend':
    app_type                => 'rack',
    port                    => $port,
    sentry_dsn              => $sentry_dsn,
    asset_pipeline          => true,
    asset_pipeline_prefixes => ['assets/email-alert-frontend'],
    vhost                   => $vhost,
    health_check_path       => '/healthcheck',
    json_health_check       => true,
  }

  Govuk::App::Envvar {
    app => 'email-alert-frontend',
  }

  govuk::app::envvar {
    "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
    "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
        varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
        value   => $email_alert_api_bearer_token;
    "${title}-EMAIL_ALERT_AUTH_TOKEN":
        varname => 'EMAIL_ALERT_AUTH_TOKEN',
        value   => $email_alert_auth_token;
  }

  if $subscription_management_enabled {
    govuk::app::envvar { "${title}-SUBSCRIPTION_MANAGEMENT_ENABLED":
      varname => 'SUBSCRIPTION_MANAGEMENT_ENABLED',
      value   => 'yes';
    }
  }
}

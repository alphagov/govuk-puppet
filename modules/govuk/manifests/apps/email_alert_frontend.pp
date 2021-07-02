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
# [*redis_host*]
#   Hostname of the Redis service
#   Default: undef
#
# [*redis_port*]
#   Port of the Redis service
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
# [*account_api_bearer_token*]
#   The bearer token to use when communicating with Account API.
#   Default: undef
#
# [*account_auth_enabled*]
#   Whether users can log in with their GOV.UK Account.
#
# [*account_confirm_email_url*]
#   URL a user who needs to confirm their account should go to (eg, to request another confirmation email).
#
# [*account_change_email_enabled*]
#   URL a user who needs to change their email address should go to.
#
class govuk::apps::email_alert_frontend(
  $vhost = 'email-alert-frontend',
  $port,
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $email_alert_api_bearer_token = undef,
  $email_alert_auth_token = undef,
  $subscription_management_enabled = false,
  $account_api_bearer_token = undef,
  $account_auth_enabled = false,
  $account_confirm_email_url = undef,
  $account_change_email_url = undef,
) {
  $app_name = 'email-alert-frontend'

  govuk::app { $app_name:
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    asset_pipeline             => true,
    asset_pipeline_prefixes    => ['assets/email-alert-frontend'],
    vhost                      => $vhost,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
    "${title}-ACCOUNT_API_BEARER_TOKEN":
        varname => 'ACCOUNT_API_BEARER_TOKEN',
        value   => $account_api_bearer_token;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
    "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
        varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
        value   => $email_alert_api_bearer_token;
    "${title}-EMAIL_ALERT_AUTH_TOKEN":
        varname => 'EMAIL_ALERT_AUTH_TOKEN',
        value   => $email_alert_auth_token;
    "${title}-GOVUK_ACCOUNT_CONFIRM_EMAIL_URL":
        varname => 'GOVUK_ACCOUNT_CONFIRM_EMAIL_URL',
        value   => $account_confirm_email_url;
    "${title}-GOVUK_ACCOUNT_CHANGE_EMAIL_URL":
        varname => 'GOVUK_ACCOUNT_CHANGE_EMAIL_URL',
        value   => $account_change_email_url;
  }

  if $subscription_management_enabled {
    govuk::app::envvar { "${title}-SUBSCRIPTION_MANAGEMENT_ENABLED":
      varname => 'SUBSCRIPTION_MANAGEMENT_ENABLED',
      value   => 'yes';
    }
  }

  if $account_auth_enabled {
    govuk::app::envvar { "${title}-FEATURE_FLAG_GOVUK_ACCOUNT":
      varname => 'FEATURE_FLAG_GOVUK_ACCOUNT',
      value   => 'enabled';
    }
  }
}

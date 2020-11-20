# == Class: govuk::apps::finder_frontend
#
# Configure the finder-frontend application
#
# === Parameters
#
# FIXME: Document all parameters
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
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*email_alert_api_bearer_token*]
#   Bearer token for communication with the email-alert-api
#
# [*account_oauth_client_id*]
#   Client ID for the Transition Checker in GOV.UK Account Manager
#
# [*account_oauth_client_secret*]
#   Client secret for the Transition Checker in GOV.UK Account Manager
#
# [*account_jwt_key_uuid*]
#   An arbitrary UUID (used to identify the JWT signing key for Transition Checker
#
# [*account_jwt_key_pem*]
#   Private key used to sign the JWT for Transition Checker
#
# [*feature_flag_accounts*]
#   Feature flag to switch GOV.UK Accounts on or off for the Transition Checker
#
# [*plek_account_manager_uri*]
#   Path to the GOV.UK Account Manager
#
class govuk::apps::finder_frontend(
  $port,
  $enabled = false,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $sentry_dsn = undef,
  $secret_key_base = undef,
  $email_alert_api_bearer_token = undef,
  $unicorn_worker_processes = undef,
  $account_oauth_client_id = undef,
  $account_oauth_client_secret = undef,
  $account_jwt_key_uuid = undef,
  $account_jwt_key_pem = undef,
  $feature_flag_accounts = false,
  $plek_account_manager_uri = undef,
) {

  if $enabled {
    govuk::app { 'finder-frontend':
      app_type                 => 'rack',
      port                     => $port,
      sentry_dsn               => $sentry_dsn,
      health_check_path        => '/healthcheck.json',
      json_health_check        => true,
      log_format_is_json       => true,
      asset_pipeline           => true,
      asset_pipeline_prefixes  => ['assets/finder-frontend'],
      nagios_memory_warning    => $nagios_memory_warning,
      nagios_memory_critical   => $nagios_memory_critical,
      unicorn_worker_processes => $unicorn_worker_processes,
      cpu_warning              => 175,
      cpu_critical             => 225,
    }
  }

  Govuk::App::Envvar {
    app => 'finder-frontend',
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
    "${title}-ACCOUNT-OAUTH-CLIENT-ID":
        varname => 'GOVUK_ACCOUNT_OAUTH_CLIENT_ID',
        value   => $account_oauth_client_id;
    "${title}-ACCOUNT-OAUTH-CLIENT-SECRET":
        varname => 'GOVUK_ACCOUNT_OAUTH_CLIENT_SECRET',
        value   => $account_oauth_client_secret;
    "${title}-ACCOUNT-JWT-KEY-UUID":
        varname => 'GOVUK_ACCOUNT_JWT_KEY_UUID',
        value   => $account_jwt_key_uuid;
    "${title}-ACCOUNT-JWT-KEY-PEM":
        varname => 'GOVUK_ACCOUNT_JWT_KEY_PEM',
        value   => $account_jwt_key_pem;
    "${title}-FEATURE-FLAG-ACCOUNTS":
        varname => 'FEATURE_FLAG_ACCOUNTS',
        value   => $feature_flag_accounts_var;
    "${title}-PLEK-ACCOUNT-MANAGER-URI":
        varname => 'PLEK_SERVICE_ACCOUNT_MANAGER_URI',
        value   => $plek_account_manager_uri;
  }

}

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
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*email_alert_api_bearer_token*]
#   Bearer token for communication with the email-alert-api
#
class govuk::apps::finder_frontend(
  $port,
  $enabled = false,
  $sentry_dsn = undef,
  $secret_key_base = undef,
  $email_alert_api_bearer_token = undef,
  $unicorn_worker_processes = undef,
) {

  if $enabled {
    govuk::app { 'finder-frontend':
      app_type                       => 'rack',
      port                           => $port,
      sentry_dsn                     => $sentry_dsn,
      has_liveness_health_check      => true,
      has_readiness_health_check     => true,
      log_format_is_json             => true,
      asset_pipeline                 => true,
      asset_pipeline_prefixes        => ['assets/finder-frontend'],
      alert_when_file_handles_exceed => 4000,
      unicorn_worker_processes       => $unicorn_worker_processes,
      cpu_warning                    => 175,
      cpu_critical                   => 225,
    }
  }

  Govuk::App::Envvar {
    app => 'finder-frontend',
  }

  govuk::app::envvar {
    "${title}-EMAIL_ALERT_API_BEARER_TOKEN":
        varname => 'EMAIL_ALERT_API_BEARER_TOKEN',
        value   => $email_alert_api_bearer_token;
    "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
  }
}

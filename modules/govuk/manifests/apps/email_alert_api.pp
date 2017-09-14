# == Class: govuk::apps::email_alert_api
#
# Email Alert API is an internal API for subscribing to and triggering email
# alerts.
#
# === Parameters
#
# [*enabled*]
#   Should the application should be enabled. Set in hiera data for each
#   environment.
#
# [*port*]
#   What port should the app run on?
#
# [*enable_procfile_worker*]
#   Should the Foreman-based background worker be enabled by default. Set in
#   hiera.
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
# [*allow_govdelivery_topic_syncing*]
#   If set to `true`, allows the running of a script which deletes all topics
#   in GovDelivery and replaces them with copies from the email alert API database.
#   Must only be configured to `true` in staging or integration, never production.
#   Default: false
#
# [*govdelivery_username*]
#   Username used to authenticate with govdelivery API
#
# [*govdelivery_password*]
#   Password used to authenticate with govdelivery API
#
# [*govdelivery_account_code*]
#   Identifier for GOV.UK within the govdelivery service
#
# [*govdelivery_hostname*]
#   Hostname for the govdelivery API (changes depending on environment)
#
# [*govdelivery_signup_form*]
#   URL to the public govdelivery page users are redirected to to enter their
#   email and subscribe (URL should include a %s to provide a topic ID)
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
class govuk::apps::email_alert_api(
  $port = '3088',
  $enabled = false,
  $enable_procfile_worker = true,
  $sidekiq_retry_critical = '20',
  $sidekiq_retry_warning = '10',
  $sidekiq_queue_size_critical = '5',
  $sidekiq_queue_size_warning = '2',
  $sidekiq_queue_latency_critical = '60',
  $sidekiq_queue_latency_warning = '30',
  $redis_host = undef,
  $redis_port = undef,
  $sentry_dsn = undef,
  $allow_govdelivery_topic_syncing = false,
  $govdelivery_username = undef,
  $govdelivery_password = undef,
  $govdelivery_account_code = undef,
  $govdelivery_hostname = undef,
  $govdelivery_signup_form = undef,
  $errbit_api_key = undef,
  $secret_key_base = undef,
) {

  if $enabled {
    govuk::app { 'email-alert-api':
      app_type           => 'rack',
      port               => $port,
      sentry_dsn         => $sentry_dsn,
      log_format_is_json => true,
      health_check_path  => '/healthcheck',
      json_health_check  => true,
    }

    include govuk_postgresql::client #installs libpq-dev package needed for pg gem

    govuk::procfile::worker {'email-alert-api':
      enable_service => $enable_procfile_worker,
    }

    govuk_logging::logstream { 'email_alert_api_sidekiq_json_log':
      logfile => '/var/apps/email-alert-api/log/sidekiq.json.log',
      fields  => {'application' => 'email-alert-api-sidekiq'},
      json    => true,
    }

    @filebeat::prospector { 'email_alert_api_sidekiq_json_log':
      paths  => ['/var/apps/email-alert-api/log/sidekiq.json.log'],
      fields => {'application' => 'email-alert-api-sidekiq'},
      json   => {'add_error_key' => true},
    }

    govuk_logging::logstream { 'govdelivery_json_log':
      logfile => '/var/apps/email-alert-api/log/govdelivery.log',
      fields  => {'application' => 'email-alert-api-govdelivery'},
      json    => true,
    }

    @filebeat::prospector { 'govdelivery_json_log':
      paths  => ['/var/apps/email-alert-api/log/govdelivery.log'],
      fields => {'application' => 'email-alert-api-govdelivery'},
      json   => {'add_error_key' => true},
    }

    Govuk::App::Envvar {
      app => 'email-alert-api',
    }

    govuk::app::envvar::redis { 'email-alert-api':
      host => $redis_host,
      port => $redis_port,
    }

    govuk::app::envvar {
      "${title}-SIDEKIQ_RETRY_CRITICAL_THRESHOLD":
          varname => 'SIDEKIQ_RETRY_SIZE_CRITICAL',
          value   => $sidekiq_retry_critical;
      "${title}-SIDEKIQ_RETRY_WARNING_THRESHOLD":
          varname => 'SIDEKIQ_RETRY_SIZE_WARNING',
          value   => $sidekiq_retry_warning;
      "${title}-SIDEKIQ_QUEUE_SIZE_CRITICAL_THRESHOLD":
          varname => 'SIDEKIQ_QUEUE_SIZE_CRITICAL',
          value   => $sidekiq_queue_size_critical;
      "${title}-SIDEKIQ_QUEUE_SIZE_WARNING_THRESHOLD":
          varname => 'SIDEKIQ_QUEUE_SIZE_WARNING',
          value   => $sidekiq_queue_size_warning;
      "${title}-SIDEKIQ_QUEUE_LATENCY_CRITICAL_THRESHOLD":
          varname => 'SIDEKIQ_QUEUE_LATENCY_CRITICAL',
          value   => $sidekiq_queue_latency_critical;
      "${title}-SIDEKIQ_QUEUE_LATENCY_WARNING_THRESHOLD":
          varname => 'SIDEKIQ_QUEUE_LATENCY_WARNING',
          value   => $sidekiq_queue_latency_warning;
      "${title}-GOVDELIVERY_USERNAME":
          varname => 'GOVDELIVERY_USERNAME',
          value   => $govdelivery_username;
      "${title}-GOVDELIVERY_PASSWORD":
          varname => 'GOVDELIVERY_PASSWORD',
          value   => $govdelivery_password;
      "${title}-GOVDELIVERY_ACCOUNT_CODE":
          varname => 'GOVDELIVERY_ACCOUNT_CODE',
          value   => $govdelivery_account_code;
      "${title}-GOVDELIVERY_HOSTNAME":
          varname => 'GOVDELIVERY_HOSTNAME',
          value   => $govdelivery_hostname;
      "${title}-GOVDELIVERY_SIGNUP_FORM":
          varname => 'GOVDELIVERY_SIGNUP_FORM',
          value   => $govdelivery_signup_form;
      "${title}-ERRBIT_API_KEY":
          varname => 'ERRBIT_API_KEY',
          value   => $errbit_api_key;
      "${title}-SECRET_KEY_BASE":
          varname => 'SECRET_KEY_BASE',
          value   => $secret_key_base;
    }

    if $allow_govdelivery_topic_syncing {
      govuk::app::envvar { "${title}-ALLOW_GOVDELIVERY_SYNC":
        varname => 'ALLOW_GOVDELIVERY_SYNC',
        value   => 'allow';
      }
    }
  }
}

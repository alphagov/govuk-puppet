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
) {

  if $enabled {
    govuk::app { 'email-alert-api':
      app_type           => 'rack',
      port               => $port,
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

    govuk_logging::logstream { 'govdelivery_json_log':
      logfile => '/var/apps/email-alert-api/log/govdelivery.log',
      fields  => {'application' => 'email-alert-api-govdelivery'},
      json    => true,
    }

    Govuk::App::Envvar {
      app => 'email-alert-api',
    }

    govuk::app::envvar::redis { 'email-alert-api':
      host => $redis_host,
      port => $redis_port,
    }

    govuk::app::envvar { "${title}-SIDEKIQ_RETRY_CRITICAL_THRESHOLD":
      varname => 'SIDEKIQ_RETRY_SIZE_CRITICAL',
      value   => $sidekiq_retry_critical;
    }

    govuk::app::envvar { "${title}-SIDEKIQ_RETRY_WARNING_THRESHOLD":
      varname => 'SIDEKIQ_RETRY_SIZE_WARNING',
      value   => $sidekiq_retry_warning;
    }

    govuk::app::envvar { "${title}-SIDEKIQ_QUEUE_SIZE_CRITICAL_THRESHOLD":
      varname => 'SIDEKIQ_QUEUE_SIZE_CRITICAL',
      value   => $sidekiq_queue_size_critical;
    }

    govuk::app::envvar { "${title}-SIDEKIQ_QUEUE_SIZE_WARNING_THRESHOLD":
      varname => 'SIDEKIQ_QUEUE_SIZE_WARNING',
      value   => $sidekiq_queue_size_warning;
    }

    govuk::app::envvar { "${title}-SIDEKIQ_QUEUE_LATENCY_CRITICAL_THRESHOLD":
      varname => 'SIDEKIQ_QUEUE_LATENCY_CRITICAL',
      value   => $sidekiq_queue_latency_critical;
    }

    govuk::app::envvar { "${title}-SIDEKIQ_QUEUE_LATENCY_WARNING_THRESHOLD":
      varname => 'SIDEKIQ_QUEUE_LATENCY_WARNING',
      value   => $sidekiq_queue_latency_warning;
    }
  }
}

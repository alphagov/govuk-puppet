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
class govuk::apps::email_alert_api(
  $port = '3088',
  $enabled = false,
  $enable_procfile_worker = true
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

    govuk::logstream { 'email_alert_api_sidekiq_json_log':
      logfile => '/var/apps/email-alert-api/log/sidekiq.json.log',
      fields  => {'application' => 'email-alert-api-sidekiq'},
      json    => true,
    }

    govuk::logstream { 'govdelivery_json_log':
      logfile => '/var/apps/email-alert-api/log/govdelivery.log',
      fields  => {'application' => 'email-alert-api-govdelivery'},
      json    => true,
    }
  }
}

# == Class: govuk::apps::email_alert_api
#
# Email Alert API is an internal API for subscribing to and triggering email
# alerts.
#
# === Parameters
#
# [*vhost_protected*]
#   Should the application be protected by basic auth.
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
  $port = 3088,
  $vhost_protected = false,
  $enabled = false,
  $enable_procfile_worker = true
) {

  if $enabled {
    govuk::app { 'email-alert-api':
      app_type           => 'rack',
      port               => $port,
      vhost_protected    => $vhost_protected,
      log_format_is_json => true,
    }

    include govuk_postgresql::client #installs libpq-dev package needed for pg gem

    govuk::procfile::worker {'email-alert-api':
      enable_service => $enable_procfile_worker,
    }
  }
}

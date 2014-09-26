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
class govuk::apps::email_alert_api(
  $port = 3088,
  $vhost_protected = false,
  $enabled = false,
) {

  if $enabled {
    govuk::app { 'email-alert-api':
      app_type           => 'rack',
      port               => $port,
      vhost_protected    => $vhost_protected,
      log_format_is_json => true,
    }
  }
}

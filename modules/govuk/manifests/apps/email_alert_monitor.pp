# == Class: govuk::apps::email_alert_monitor
#
# An app to monitor email alerts sent through the GOV.UK Publishing Platform.
# Read more: https://github.com/alphagov/email-alert-monitor
#
# === Parameters
#
# [*port*]
#   The port that email-alert-monitor is served on.
#   Default: 3094
#
# [*enabled*]
#   Feature flag to allow the app to be deployed to an environment.
#   Default: false
#
class govuk::apps::email_alert_monitor(
  $port = 3094,
  $enabled = false
) {
  if $enabled {
    govuk::app { 'email-alert-monitor':
      app_type           => 'rack',
      port               => $port,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
    }
  }
}

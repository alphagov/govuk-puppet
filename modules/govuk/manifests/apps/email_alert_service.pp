# == Class: govuk::apps::email_alert_service
#
# This is a message queue consumer that triggers email alerts when documents are
# published with a major change.
#
# === Parameters
#
# [*enabled*]
#   Should the application should be enabled. Set in hiera data for each
#   environment.
#
class govuk::apps::email_alert_service (
  $enabled = false,
) {
  if $enabled {
    govuk::app { 'email-alert-service':
      app_type           => 'bare',
      enable_nginx_vhost => false,
      command            => './bin/email_alert_service',
    }
  }
}

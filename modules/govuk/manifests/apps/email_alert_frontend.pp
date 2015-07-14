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
#
# [*port*]
#   What port should the app run on?
#
class govuk::apps::email_alert_frontend(
  $vhost,
  $port = 3099,
) {
  govuk::app { 'email-alert-frontend':
    app_type              => 'rack',
    port                  => $port,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'email-alert-frontend',
    vhost                 => $vhost,
  }
}

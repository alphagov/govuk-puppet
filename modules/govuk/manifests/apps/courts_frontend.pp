# == Class: govuk::apps::courts_frontend
#
# An frontend app to display courts and tribunals information on GOV.UK.
# Read more: https://github.com/alphagov/courts-frontend
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#
# [*port*]
#   The port that courts-frontend is served on.
#   Default: 3095
#
# [*enabled*]
#   Feature flag to allow the app to be deployed to an environment.
#   Default: false
#
class govuk::apps::courts_frontend(
  $vhost,
  $port = '3095',
  $enabled = false
) {
  if $enabled {
    govuk::app { 'courts-frontend':
      # FIXME: delete this class and remove it from hieradata when this has been deployed
      ensure                => absent,
      app_type              => 'rack',
      port                  => $port,
      asset_pipeline        => true,
      asset_pipeline_prefix => 'courts-frontend',
      health_check_path     => '/healthcheck',
      log_format_is_json    => true,
      vhost                 => $vhost,
    }
  }
}

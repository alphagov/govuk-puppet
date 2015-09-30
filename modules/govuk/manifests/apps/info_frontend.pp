# == Class: govuk::apps::info_frontend
#
class govuk::apps::info_frontend(
  # The default port that the rack application will start on.
  $port = '3085',

  # Whether the app should be present in a given environment.
  $enabled = false,
) {
  govuk::app { 'info-frontend':
    app_type              => 'rack',
    port                  => $port,
    vhost_aliases         => ['info-frontend'],
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'info-frontend',
  }
}

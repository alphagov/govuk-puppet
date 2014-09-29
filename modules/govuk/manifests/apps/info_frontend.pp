# == Class: govuk::apps::info_frontend
#
class govuk::apps::info_frontend(
  # The default port that the rack application will start on.
  $port = 3085,

  # Should this vhost be protected with HTTP Basic auth?
  $vhost_protected = false,

  # Whether the app should be present in a given environment.
  $enabled = false,
) {
  if $enabled {
    govuk::app { 'info-frontend':
      app_type              => 'rack',
      port                  => $port,
      vhost_protected       => $vhost_protected,
      vhost_aliases         => ['info-frontend'],
      log_format_is_json    => true,
      asset_pipeline        => true,
      asset_pipeline_prefix => 'info-frontend',
    }
  }
}

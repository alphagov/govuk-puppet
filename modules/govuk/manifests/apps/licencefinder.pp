# == Class: govuk::apps::licencefinder
#
# An application for finding licences on gov.uk
#
# === Parameters
#
# [*port*]
#   The port that licence finder is served on.
#   Default: 3093
#
class govuk::apps::licencefinder(
  $port = '3014',
) {
  govuk::app { 'licencefinder':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/licence-finder',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'licencefinder',
  }
}

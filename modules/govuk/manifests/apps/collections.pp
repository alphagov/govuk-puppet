# == Class: govuk::apps::collections
#
# Collections is an app to serve collection pages from the content store
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#
# [*port*]
#   What port should the app run on?
#
class govuk::apps::collections(
  $vhost,
  $port = '3070',
) {
  govuk::app { 'collections':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/topic/oil-and-gas',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'collections',
    vhost                 => $vhost,
  }
}

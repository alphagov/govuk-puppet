# == Class: govuk::apps::share_sale_publisher
#
# App to publish shares sale.
# FIXME: Remove this class once the app is stopped on all machines.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3119
#
class govuk::apps::share_sale_publisher(
  $port = 3119,
) {
  $app_name = 'share-sale-publisher'

  govuk::app { $app_name:
    ensure                => absent,
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/healthcheck',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => share-sale-publisher,
  }
}

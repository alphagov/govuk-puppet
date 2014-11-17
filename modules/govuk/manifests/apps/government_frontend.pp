# == Class: govuk::apps::government_frontend
#
# Government Frontend is an app to serve content pages form the content store
#
# === Parameters
#
# [*enabled*]
#   Should the application should be enabled. Set in hiera data for each
#   environment.
#
# [*port*]
#   What port should the app run on?
#
# [*vhost_protected*]
#   Should the application be protected by basic auth.
#
class govuk::apps::government_frontend(
  $port = 3090,
  $vhost_protected = false,
) {
  govuk::app { 'government-frontend':
    app_type              => 'rack',
    port                  => $port,
    vhost_ssl_only        => true,
    vhost_protected       => $vhost_protected,
    health_check_path     => '/healthcheck',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'government-frontend',
  }
}

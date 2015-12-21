#
#
#
class govuk::apps::multipart_frontend(
  $vhost,
  $port = '3112',
  $enabled = false,
) {
  govuk::app { 'multipart-frontend':
    app_type              => 'rack',
    port                  => $port,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'multipart-frontend',
    vhost                 => $vhost,
    health_check_path     => '/',
  }
}

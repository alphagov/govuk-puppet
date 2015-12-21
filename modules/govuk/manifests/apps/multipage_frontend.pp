# Multipage-frontend is a Ruby on Rails frontend application
# for rendering content grouped in multiple parts or pages.
#
class govuk::apps::multipage_frontend(
  $vhost,
  $port = '3112',
  $enabled = false,
) {
  govuk::app { 'multipage-frontend':
    app_type              => 'rack',
    port                  => $port,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'multipage-frontend',
    vhost                 => $vhost,
    health_check_path     => '/healthcheck',
  }
}

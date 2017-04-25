# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::contacts_frontend (
  $vhost = 'contacts-frontend',
  $port = '3074',
) {
  govuk::app { 'contacts-frontend':
    ensure                => 'absent',
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/healthcheck',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'contacts-frontend',
    vhost                 => $vhost,
  }
}

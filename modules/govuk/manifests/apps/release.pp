# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::release( $port = 3036 ) {
  govuk::app { 'release':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    vhost_protected    => false,
    asset_pipeline     => true,
  }
}

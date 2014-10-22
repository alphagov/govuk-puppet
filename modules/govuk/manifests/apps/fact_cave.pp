# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::fact_cave( $port = 3048 ) {
  govuk::app { 'fact-cave':
    ensure             => absent,
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }
}

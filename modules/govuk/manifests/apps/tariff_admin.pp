# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::tariff_admin($port = 3046) {
  govuk::app { 'tariff-admin':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/',
    log_format_is_json => true,
    deny_framing       => true,
  }
}

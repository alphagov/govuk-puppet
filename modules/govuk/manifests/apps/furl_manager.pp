# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::furl_manager(
  $port = 3076,
  $enabled = false
) {
  if ($enabled) {
    govuk::app { 'furl-manager':
      app_type           => 'rack',
      port               => $port,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
    }
  }
}

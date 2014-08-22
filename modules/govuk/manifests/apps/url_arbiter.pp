# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::url_arbiter(
  $port = 3034,
  $enabled = false,
) {
  if $enabled {

    govuk::app { 'url-arbiter':
      app_type           => 'rack',
      port               => $port,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
    }

    include govuk_postgresql::client #installs libpq-dev package needed for pg gem
  }
}

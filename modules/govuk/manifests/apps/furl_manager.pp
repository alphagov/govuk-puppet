# FIXME remove this class once it's been cleaned up from preview
class govuk::apps::furl_manager(
  $port = 3076,
  $enabled = false
) {
  govuk::app { 'furl-manager':
    ensure             => absent,
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }
}

# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::router_api(
  $port = 3056,
  $secret_key_base = undef,
) {
  govuk::app { 'router-api':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      app     => 'router-api',
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }
}

define nginx::config::vhost::dev_proxy(
  $to,
  $aliases = [],
  $extra_config = ''
) {
  nginx::config::site { $name:
    content => template('nginx/dev-proxy-vhost.conf'),
  }
}

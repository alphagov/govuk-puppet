define nginx::config::vhost::dev_proxy($to, $aliases = []) {
  nginx::config::site { $name:
    content => template('nginx/dev-proxy-vhost.conf'),
  }
}

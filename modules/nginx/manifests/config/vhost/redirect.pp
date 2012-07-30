define nginx::config::vhost::redirect($to) {
  nginx::config::site { $name:
    content => template('nginx/redirect-vhost.conf'),
  }
  nginx::config::ssl { $name: }
}

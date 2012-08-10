define nginx::config::vhost::mirror ($aliases = [], $ssl_only = false) {

  nginx::config::site { $name:
    content => template('nginx/mirror-vhost.conf')
  }
  nginx::config::ssl { $name: }

}


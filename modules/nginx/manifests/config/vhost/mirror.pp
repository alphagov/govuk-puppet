define nginx::config::vhost::mirror ($aliases = [], $ssl_only = false) {
  # @nagios::check for 5xx errors
  # cron for logster
  # graylogtail::collect for access and errors
  # htpasswd

  nginx::config::site { $name:
    content => template('nginx/mirror-vhost.conf') 
  }
  nginx::config::ssl { $name: }
}


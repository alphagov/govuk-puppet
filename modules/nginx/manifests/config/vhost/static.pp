define nginx::config::vhost::static($protected = true, $aliases = [], $ssl_only = false) {
  nginx::config::ssl { $name: }
  nginx::config::site { $name:
    content => template('nginx/static-vhost.conf'),
  }

  case $protected {
    default: {
      file { "/etc/nginx/htpasswd/htpasswd.$name":
        ensure => present,
        source => [
          "puppet:///modules/nginx/htpasswd.$name",
          'puppet:///modules/nginx/htpasswd.backend',
          'puppet:///modules/nginx/htpasswd.default'
        ],
      }
    }
    false: {
      file { "/etc/nginx/htpasswd/htpasswd.$name":
        ensure => absent
      }
    }
  }
}

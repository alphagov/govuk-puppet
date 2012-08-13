define nginx::config::vhost::proxy(
  $to,
  $aliases = [],
  $protected = true,
  $ssl_only = false,
  $extra_config = ''
) {

  nginx::config::ssl { $name: }
  nginx::config::site { $name:
    content => template('nginx/proxy-vhost.conf'),
  }

  case $protected {
    default: {
      file { "/etc/nginx/htpasswd/htpasswd.$name":
        ensure => present,
        source => [
          "puppet:///modules/nginx/htpasswd.$name",
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

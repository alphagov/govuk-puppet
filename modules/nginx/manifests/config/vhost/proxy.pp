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

  @@nagios::check { "check_nginx_5xx_${name}_on_${::hostname}":
    check_command       => "check_ganglia_metric!${name}_nginx_http_5xx!0.05!0.1",
    service_description => "check nginx error rate for ${name}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
  cron { "logster-nginx-$name":
    command => "/usr/sbin/logster --metric-prefix $name NginxGangliaLogster /var/log/nginx/${name}-access.log",
    user    => root,
    minute  => '*/2'
  }

  graylogtail::collect { "graylogtail-access-$name":
    log_file => "/var/log/nginx/${name}-access.log",
    facility => $name,
  }
  graylogtail::collect { "graylogtail-errors-$name":
    log_file => "/var/log/nginx/${name}-error.log",
    facility => $name,
    level    => 'error',
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

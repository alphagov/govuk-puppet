define nginx::config::vhost::proxy(
  $to,
  $aliases = [],
  $protected = true,
  $ssl_only = false,
  $extra_config = ''
) {

  if $::govuk_provider == 'sky' {
    $proxy_vhost_template = 'nginx/proxy-vhost.conf.sky'
  } else {
    $proxy_vhost_template = 'nginx/proxy-vhost.conf'
  }

  nginx::config::ssl { $name: }
  nginx::config::site { $name:
    content => template($proxy_vhost_template),
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

  @logster::cronjob { "nginx-vhost-${title}":
    args => "--metric-prefix ${title} NginxGangliaLogster /var/log/nginx/${title}-access.log",
  }

  @@nagios::check { "check_nginx_5xx_${title}_on_${::hostname}":
    check_command       => "check_ganglia_metric!${title}_nginx_http_5xx!0.05!0.1",
    service_description => "check nginx error rate for ${title}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

}

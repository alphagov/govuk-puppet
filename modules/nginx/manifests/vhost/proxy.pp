define nginx::vhost::proxy($to, $aliases = [], $protected = true, $ssl_only = false) {
  file { "/etc/nginx/sites-available/$name":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nginx/proxy-vhost.conf'),
    require => Class['nginx::install'],
    notify  => Exec['nginx_reload'],
  }

  @@nagios_service { "check_nginx_5xx_${name}_on_${::hostname}":
    use                 => 'generic-service',
    check_command       => "check_ganglia_metric!${name}_nginx_http_5xx!0.05!0.1",
    service_description => "check nginx error rate for ${name}",
    host_name           => "${::govuk_class}-${::hostname}",
    target              => '//etc/nagios3/conf.d/nagios_service.cfg',
  }

  cron { "logster-nginx-$name":
    command => "/usr/sbin/logster --metric-prefix $name NginxGangliaLogster /var/log/nginx/${name}-access_log",
    user    => root,
    minute  => '*/2'
  }

  graylogtail::collect { "graylogtail-access-$name":
    log_file => "/var/log/nginx/${name}-access_log",
    facility => $name,
  }
  graylogtail::collect { "graylogtail-errors-$name":
    log_file => "/var/log/nginx/${name}-error_log",
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

  nginx::ssl { $name: }
  nginx::site { $name: }
}

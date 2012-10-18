define nginx::config::vhost::mirror ($aliases = [], $port = "443", $certtype = 'wildcard_alphagov') {

  nginx::config::site { $title:
    content => template('nginx/mirror-vhost.conf')
  }
  nginx::config::ssl { $title: certtype => $certtype }

  file { '/var/www/www.gov.uk':
    ensure  => link,
    target  => '/var/lib/govuk_mirror/current',
    require => File['/var/www'],
  }

  @logster::cronjob { "nginx-vhost-${title}":
    args => "--metric-prefix ${title} NginxGangliaLogster /var/log/nginx/${title}-access.log",
  }

  @@nagios::check { "check_nginx_5xx_${title}_on_${::hostname}":
    check_command       => "check_ganglia_metric!${title}_nginx_http_5xx!0.5!1.0",
    service_description => "${title} nginx 5xx rate too high",
    host_name           => "${::govuk_class}-${::hostname}",
  }

}

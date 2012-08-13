define nginx::config::site($content = 'UNSET', $source = 'UNSET') {

  if $content != 'UNSET' {
    file { "/etc/nginx/sites-available/$title":
      ensure  => present,
      require => Class['nginx::package'],
      notify  => Class['nginx::service'],
      content => $content,
    }
  } elsif $source != 'UNSET' {
    file { "/etc/nginx/sites-available/$title":
      ensure  => present,
      require => Class['nginx::package'],
      notify  => Class['nginx::service'],
      source  => $source,
    }
  } else {
    fail 'You must supply one of $content or $source to nginx::config::site'
  }

  file { "/etc/nginx/sites-enabled/$title":
    ensure  => link,
    target  => "/etc/nginx/sites-available/$title",
    require => [Class['nginx::package'], File["/etc/nginx/sites-available/$title"]],
    notify  => Class['nginx::service']
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

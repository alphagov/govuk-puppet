class router::nginx {
  $platform = $::govuk_platform

  nginx::config::ssl { "www.${platform}.alphagov.co.uk":
    certtype => 'wildcard_alphagov'
  }

  nginx::config::ssl { 'www.gov.uk':
    certtype => 'www'
  }

  nginx::config::site { 'www.gov.uk':
    content => template('router/base.conf.erb'),
  }

  file { '/etc/nginx/router_routes.conf':
    ensure  => present,
    content => template('router/routes.conf.erb'),
    notify  => Class['nginx::service'],
  }

  # The cache/router also contains a flat site as a backup for software failures
  nginx::config::vhost::mirror { "flatsite.${platform}.alphagov.co.uk":
    port     => '444',
    certtype => 'wildcard_alphagov',
  }

  file { '/var/www/fallback':
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy',
  }

  file { '/var/www/fallback/fallback_holding.html':
    ensure => file,
    source => 'puppet:///modules/router/fallback.html',
    owner  => 'deploy',
    group  => 'deploy',
  }

  @@nagios::check { "check_nginx_5xx_on_${::hostname}":
    check_command       => 'check_ganglia_metric!nginx_http_5xx!0.05!0.1',
    service_description => 'check nginx error rate',
    host_name           => "${::govuk_class}-${::hostname}",
  }
}

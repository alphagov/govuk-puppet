class router::nginx {
  $platform = $::govuk_platform
  $app_domain = extlookup('app_domain')

  nginx::config::ssl { "www.${app_domain}":
    certtype => 'wildcard_alphagov'
  }

  nginx::config::site { 'www.${app_domain}':
    content => template('router/base.conf.erb'),
  }

  nginx::config::site { 'router-replacement-port8080':
    source  => 'puppet:///modules/router/etc/nginx/router-replacement-port8080.conf',
  }

  file { '/etc/nginx/router_routes.conf':
    ensure  => present,
    content => template('router/routes.conf.erb'),
    notify  => Class['nginx::service'],
  }

  file { '/usr/share/nginx':
    ensure  => directory,
  }

  file { '/usr/share/nginx/www':
    ensure  => directory,
    mode    => '0755',
    owner   => 'deploy',
    group   => 'deploy',
    require => File['/usr/share/nginx'];
  }

  router::errorpage {['404','406','410','418','500','503','504']:
    require => File['/usr/share/nginx/www'],
  }

  # The cache/router also contains a flat site as a backup for software failures
  nginx::config::vhost::mirror { "flatsite.${app_domain}":
    port     => '444',
    certtype => 'wildcard_alphagov',
  }

  file { '/var/www/akamai_test_object.txt':
    ensure => present,
    source => 'puppet:///modules/router/akamai_test_object.txt',
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

  @logstash::collector { 'router':
        source => 'puppet:///modules/router/etc/logstash/logstash-client/router.conf',
  }

  @logster::cronjob { 'lb':
    args => "NginxGangliaLogster /var/log/nginx/lb-access.log",
  }

  @@nagios::check { "check_nginx_5xx_on_${::hostname}":
    check_command       => 'check_ganglia_metric!nginx_http_5xx!1!5',
    service_description => 'router nginx high 5xx rate',
    host_name           => $::fqdn,
  }
}

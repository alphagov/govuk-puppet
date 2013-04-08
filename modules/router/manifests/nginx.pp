class router::nginx (
  $vhost_protected
) {
  $platform = $::govuk_platform
  $app_domain = extlookup('app_domain')

  nginx::config::ssl { "www.${app_domain}":
    certtype => 'wildcard_alphagov'
  }

  nginx::config::ssl { 'www.gov.uk':
    certtype => 'www'
  }

  nginx::config::site { 'www.gov.uk':
    content         => template('router/base.conf.erb'),
    vhost_protected => $vhost_protected,
  }

  @ufw::allow { "allow-http-8080-from-all":
    port => 8080,
  }

  nginx::config::site { 'router-replacement-port8080':
    source  => 'puppet:///modules/router/etc/nginx/router-replacement-port8080.conf',
  }

  file { '/etc/nginx/router_routes.conf':
    ensure  => present,
    content => template('router/routes.conf.erb'),
    notify  => Class['nginx::service'],
  }
  nginx::log {
    'lb-json.event.access.log':
      json      => true,
      logstream => true;
    'lb-access.log':
      logstream => false;
    'lb-error.log':
      logstream => true;
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

  @logster::cronjob { 'lb':
    file    => '/var/log/nginx/lb-access.log',
    prefix  => 'nginx_logs',
  }

  # FIXME: keepLastValue() because logster only runs every 2m.
  @@nagios::check { "check_nginx_5xx_on_${::hostname}":
    check_command       => "check_graphite_metric_since!keepLastValue(${::fqdn_underscore}.nginx_logs.http_5xx)!3minutes!1!5",
    service_description => 'router nginx high 5xx rate',
    host_name           => $::fqdn,
  }
}

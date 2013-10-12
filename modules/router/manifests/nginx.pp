# == Class: router::nginx
#
# Nginx configs for "cache" nodes:
#
# - Forwards requests to Varnish over loopback (which subsequently routes to
#   the correct frontend/backend).
# - Performs some early redirects and prevents them travelling down the
#   stack for performance reasons.
# - Intercepts error responses and replaces them with stylised pages. These
#   are periodically fetched from static/assets and stored locally.
#
# === Parameters
#
# [*vhost_protected*]
#   Mandatory boolean value. Whether to enable BasicAuth or not. Used in
#   environments where origin is not firewalled.
#
# [*real_ip_header*]
#   Invokes [real_ip](http://wiki.nginx.org/HttpRealipModule) to replace
#   `$remote_addr` with an address from the named header. The header must be
#   inserted by an upstream CDN or L7 load balancer. It *must* not be
#   spoofable by the originating client.
#
#   Default: '', which will disable this functionality.
#
class router::nginx (
  $vhost_protected,
  $real_ip_header = ''
) {
  include router::assets_origin
  include router::fco_services

  $app_domain = extlookup('app_domain')

  nginx::config::ssl { "www.${app_domain}":
    certtype => 'wildcard_alphagov'
  }

  nginx::config::ssl { 'www.gov.uk':
    certtype => 'www'
  }

  nginx::config::site { 'www.gov.uk':
    content         => template('router/base.conf.erb'),
  }

  @ufw::allow { 'allow-http-8080-from-all':
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
      json          => true,
      logstream     => true,
      statsd_metric => "${::fqdn_underscore}.nginx_logs.www-origin.http_%{@fields.status}",
      statsd_timers => [{metric => "${::fqdn_underscore}.nginx_logs.www-origin.time_request",
                          value => '@fields.request_time'}];
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
  @@nagios::check::graphite { "check_nginx_5xx_on_${::hostname}":
    target    => "keepLastValue(${::fqdn_underscore}.nginx_logs.http_5xx)",
    warning   => 5,
    critical  => 15,
    use       => 'govuk_urgent_priority',
    from      => '3minutes',
    desc      => 'router nginx high 5xx rate',
    host_name => $::fqdn,
  }
}

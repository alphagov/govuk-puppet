# == Class: router::nginx
#
# Nginx configs for "cache" nodes:
#
# - Forwards requests to Varnish over loopback.
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
# [*rate_limit_tokens*]
#   Array of token strings that can be passed in the header Rate-Limit-Token
#   to bypass rate limiting. Each application should have its own token.
#   Default: []
#
class router::nginx (
  $vhost_protected,
  $real_ip_header = '',
  $rate_limit_tokens = [],
) {
  validate_array($rate_limit_tokens)

  include router::assets_origin

  $app_domain = hiera('app_domain')

  nginx::config::ssl { "www.${app_domain}":
    certtype => 'wildcard_alphagov'
  }

  nginx::config::ssl { 'www.gov.uk':
    certtype => 'www'
  }

  nginx::conf { 'rate-limiting':
    content => template('router/rate-limiting.conf.erb'),
  }

  # Set default vhost that immediately closes the connection if no
  # HTTP Host header is specified, with the exception of the /__varnish_check__
  # endpoint which is required for load balancer health checks
  nginx::config::site { 'default':
    content => template('router/default-vhost.conf.erb'),
  }

  file { '/etc/nginx/router_include.conf':
    ensure  => present,
    content => template('router/router_include.conf.erb'),
    notify  => Class['nginx::service'],
  }
  nginx::config::site { 'www.gov.uk':
    content => template('router/base.conf.erb'),
    require => File['/etc/nginx/router_include.conf'],
  }

  @ufw::allow { 'allow-http-8080-from-all':
    port => 8080,
  }

  nginx::config::site { 'router-replacement-port8080':
    source  => 'puppet:///modules/router/etc/nginx/router-replacement-port8080.conf',
  }

  nginx::log {
    'lb-json.event.access.log':
      json          => true,
      logstream     => present,
      statsd_metric => "${::fqdn_underscore}.nginx_logs.www-origin.http_%{@fields.status}",
      statsd_timers => [{metric => "${::fqdn_underscore}.nginx_logs.www-origin.time_request",
                          value => '@fields.request_time'}];
    'lb-access.log':
      logstream => absent;
    'lb-error.log':
      logstream => present;
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

  router::errorpage {['400', '404','406','410','418','500','503','504']:
    require => File['/usr/share/nginx/www'],
  }

  @@icinga::check::graphite { "check_nginx_5xx_on_${::hostname}":
    target    => "transformNull(stats.${::fqdn_underscore}.nginx_logs.www-origin.http_5xx,0)",
    warning   => 0.3,
    critical  => 0.6,
    use       => 'govuk_urgent_priority',
    from      => '3minutes',
    desc      => 'router nginx high 5xx rate',
    host_name => $::fqdn,
    notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html?highlight=nagios#nginx-5xx-rate-too-high-for-many-apps-boxes',
  }
}

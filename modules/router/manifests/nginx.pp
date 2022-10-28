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
# [*app_specific_static_asset_routes*]
#   Hash of paths => vhost_names.  Each entry will be added as a route in the vhost
#
# [*vhost_protected*]
#   Mandatory boolean value. Whether to enable BasicAuth or not. Used in
#   environments where origin is not firewalled.
#
# [*page_ttl_404*]
#   Number of seconds to cache error pages.
#
#   Default: '30'
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
# [*check_requests_warning*]
#   Minimum number of requests before triggering a warning alert in Icinga.
#
#  Default: @25 (below 25)
#
# [*check_requests_critical*]
#   Minimum number of requests before triggering a warning alert in Icinga.
#
#   Default: @10 (below 10)
#
# [*robotstxt*]
#
#  text to put in a robots.txt file
#
# Default: ''
#
# [*proxy_busy_buffers_size*]
#
#  limits the total size of buffers that can be busy sending a response to the client while the response is not yet fully read
#
# Default: '16k'
#
# [*proxy_buffers*]
#
#  Sets the number and size of the buffers used for reading a response from the proxied server, for a single connection
#
# Default: '8 8k'
#
# [*proxy_buffer_size*]
#
#  Sets the size of the buffer used for reading the first part of the response received from the proxied server
#
# Default: '8k'
#
class router::nginx (
  $app_specific_static_asset_routes = {},
  $vhost_protected,
  $page_ttl_404 = '30',
  $real_ip_header = '',
  $rate_limit_tokens = [],
  $check_requests_warning = '@25',
  $check_requests_critical = '@10',
  $robotstxt = '',
  $proxy_busy_buffers_size = '16k',
  $proxy_buffers = '8 8k',
  $proxy_buffer_size = '8k',
) {
  validate_array($rate_limit_tokens)

  class { 'router::assets_origin':
    real_ip_header => $real_ip_header,
  }

  class { 'router::draft_assets':
    real_ip_header => $real_ip_header,
  }

  $app_domain = hiera('app_domain')
  $app_domain_internal = hiera('app_domain_internal')

  nginx::config::ssl { "www.${app_domain}":
    certtype => 'wildcard_publishing',
  }

  nginx::config::ssl { 'www.gov.uk':
    certtype => 'www',
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

  nginx::log {
    'lb-json.event.access.log':
      json          => true,
      logstream     => present,
      statsd_metric => "${::fqdn_metrics}.nginx_logs.www-origin.http_%{status}",
      statsd_timers => [{metric => "${::fqdn_metrics}.nginx_logs.www-origin.time_request",
                          value => 'request_time'}];
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

  file { '/usr/share/nginx/www/robots.txt':
    ensure  => present,
    content => $robotstxt,
    require => File['/usr/share/nginx/www'],
  }

  router::errorpage {['400', '401', '403', '404', '405', '406', '410', '422', '429', '500', '502', '503', '504']:
    require => File['/usr/share/nginx/www'],
  }

  $graphite_5xx_target = "movingMedian(transformNull(stats.${::fqdn_metrics}.nginx_logs.www-origin.http_5xx,0),\"5min\")"

  @@icinga::check::graphite { "check_nginx_5xx_on_${::hostname}":
    target    => $graphite_5xx_target,
    warning   => 0.3,
    critical  => 0.9,
    use       => 'govuk_urgent_priority',
    from      => '15minutes',
    desc      => '5xx rate for www-origin',
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(high-nginx-5xx-rate),
  }

  @@icinga::check::graphite { "check_nginx_requests_${::hostname}":
    target              => "${::fqdn_metrics}.nginx.nginx_requests",
    warning             => $check_requests_warning,
    critical            => $check_requests_critical,
    desc                => 'Minimum HTTP request rate for www-origin',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(nginx-requests-too-low),
    notification_period => 'inoffice',
  }
}

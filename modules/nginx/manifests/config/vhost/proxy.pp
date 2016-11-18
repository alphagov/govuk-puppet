# == Define: nginx::config::vhost::proxy
#
# Simple Nginx vhost which reverse proxies to another location.
#
# === Parameters
#
# [*to*]
#   Array of upstream servers to reverse proxy to.
#
# [*to_ssl*]
#   Boolean whether the upstream servers are running on HTTPS/443.
#   Default: false
#
# [*aliases*]
#   Other hostnames to serve the app on
#
# [*custom_http_host*]
#   This setting allows the default HTTP Host header to be overridden.
#
#   An example of where this is useful is if requests are handled by different
#   backend applications but use the same hostname.
#   Default: undef
#
# [*extra_config*]
#   A string containing additional nginx config
#
# [*extra_app_config*]
#   A string containing additional nginx config for the `app` location block
#
# [*deny_framing*]
#   Boolean, whether nginx should instruct browsers to not allow framing the page
#
# [*protected*]
#   Boolean, whether or not the vhost should be protected with basic auth
#
# [*protected_location*]
#   Prefix path to protect with basic auth, defaults to everything
#
# [*root*]
#   The root directory for nginx to serve requests from
#
# [*ssl_only*]
#   Whether the app should only be available on a secure connection
#
# [*is_default_vhost*]
#   Boolean, whether to set `default_server` in nginx
#
# [*ssl_certtype*]
#   Type of certificate from the predefined list in `nginx::config::ssl`.
#   Default: 'wildcard_publishing'
#
# [*hidden_paths*]
#   Array of paths that nginx will force to return an error
#
# [*single_page_app*]
#   Direct all requests that are not static files to the file specified by
#   the parameter
#
# [*read_timeout*]
#   Configure the amount of time the proxy vhost will wait before returning
#   a 504 to the client
#
# [*ensure*]
#   Whether to create the nginx vhost, present/absent
#
# [*alert_5xx_warning_rate*]
#   The error percentage that triggers a warning alert
#
# [*alert_5xx_critical_rate*]
#   The error percentage that triggers a critical alert
#
# [*proxy_http_version_1_1_enabled*]
#   Boolean, whether to enable HTTP/1.1 for proxying from the Nginx vhost
#   to the app server.
#
define nginx::config::vhost::proxy(
  $to,
  $to_ssl = false,
  $aliases = [],
  $custom_http_host = undef,
  $extra_config = '',
  $extra_app_config = '',
  $deny_framing = false,
  $protected = true,
  $protected_location = '/',
  $root = "/data/vhost/${title}/current/public",
  $ssl_only = false,
  $is_default_vhost = false,
  $ssl_certtype = 'wildcard_publishing',
  $hidden_paths = [],
  $single_page_app = false,
  $read_timeout = 15,
  $ensure = 'present',
  $alert_5xx_warning_rate = 0.05,
  $alert_5xx_critical_rate = 0.1,
  $proxy_http_version_1_1_enabled = false,
) {
  validate_re($ensure, '^(absent|present)$', 'Invalid ensure value')

  include govuk_htpasswd

  $proxy_vhost_template = 'nginx/proxy-vhost.conf'
  $logpath = '/var/log/nginx'
  $access_log = "${name}-access.log"
  $json_access_log = "${name}-json.event.access.log"
  $error_log = "${name}-error.log"
  $title_escaped = regsubst($title, '\.', '_', 'G')

  $to_port = $to_ssl ? {
    true    => ':443',
    default => '',
  }
  $to_proto = $to_ssl ? {
    true    => 'https://',
    default => 'http://',
  }

  # Whether to enable SSL. Used by template.
  $enable_ssl = hiera('nginx_enable_ssl', true)

  nginx::config::ssl { $name:
    certtype => $ssl_certtype,
  }
  nginx::config::site { $name:
    ensure  => $ensure,
    content => template($proxy_vhost_template),
  }

  $counter_basename = "${::fqdn_metrics}.nginx_logs.${title_escaped}"

  nginx::log {
    $json_access_log:
      json          => true,
      logpath       => $logpath,
      logstream     => $ensure,
      statsd_metric => "${counter_basename}.http_%{@fields.status}",
      statsd_timers => [{metric => "${counter_basename}.time_request",
                          value => '@fields.request_time'}];
    $error_log:
      logpath   => $logpath,
      logstream => $ensure;
  }

  statsd::counter { "${counter_basename}.http_500": }

  @@icinga::check::graphite { "check_nginx_5xx_${title}_on_${::hostname}":
    ensure    => $ensure,
    target    => "transformNull(stats.${counter_basename}.http_5xx,0)",
    warning   => $alert_5xx_warning_rate,
    critical  => $alert_5xx_critical_rate,
    from      => '3minutes',
    desc      => "${title} nginx 5xx rate too high",
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(nginx-5xx-rate-too-high-for-many-apps-boxes),
  }

}

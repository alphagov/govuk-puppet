# == Define: nginx::config::vhost::static
#
# Simple Nginx vhost which serves static content from disk
#
# === Parameters
#
# [*aliases*]
#   Other hostnames to serve the app on
#
# [*locations*]
#   A Hash mapping http paths to filesystem paths
#   eg. {'/foo' => '/data/uploads/foo'}
#
# [*extra_config*]
#   A string containing additional nginx config
#
# [*deny_framing*]
#   Boolean, whether nginx should instruct browsers to not allow framing the page
#
# [*logstream*]
#   Whether nginx logs should be shipped to the logging box
#
# [*is_default_vhost*]
#   Boolean, whether to set `default_server` in nginx
#
# [*ssl_certtype*]
#   Type of certificate from the predefined list in `nginx::config::ssl`.
#   Default: 'wildcard_publishing'
#
# [*ensure*]
#   Whether to create the nginx vhost, present/absent
#
define nginx::config::vhost::static(
  $aliases = [],
  $locations = {},
  $extra_config = '',
  $deny_framing = false,
  $logstream = present,
  $is_default_vhost = false,
  $ssl_certtype = 'wildcard_publishing',
  $ensure = 'present',
) {
  validate_re($ensure, '^(absent|present)$', 'Invalid ensure value')

  $static_vhost_template = 'nginx/static-vhost.conf'
  $logpath = '/var/log/nginx'
  $access_log = "${name}-access.log"
  $json_access_log = "${name}-json.event.access.log"
  $error_log = "${name}-error.log"
  $title_escaped = regsubst($title, '\.', '_', 'G')

  # Whether to enable SSL. Used by template.
  $enable_ssl = hiera('nginx_enable_ssl', true)

  nginx::config::ssl { $name:
    certtype => $ssl_certtype,
  }
  nginx::config::site { $name:
    ensure  => $ensure,
    content => template($static_vhost_template),
  }

  $counter_basename = "${::fqdn_metrics}.nginx_logs.${title_escaped}"

  $logstream_ensure = $ensure ? {
    'present' => $logstream,
    default   => $ensure,
  }

  nginx::log {
    $json_access_log:
      json          => true,
      logpath       => $logpath,
      logstream     => $logstream_ensure,
      statsd_metric => "${counter_basename}.http_%{@fields.status}",
      statsd_timers => [{metric => "${counter_basename}.time_request",
                          value => '@fields.request_time'}];
    $error_log:
      logpath   => $logpath,
      logstream => $logstream_ensure;
  }
}

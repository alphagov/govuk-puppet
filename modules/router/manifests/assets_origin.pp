# = Class: router::assets_origin
#
# Configure vhost for serving external-facing assets.
#
# === Parameters
#
# [*asset_routes*]
#   Hash of paths => vhost_names.  Each entry will be added as a route in the vhost
#
# [*real_ip_header*]
#   Uses the Nginx realip module (http://nginx.org/en/docs/http/ngx_http_realip_module.html)
#   to change the client IP address to the one in the specified HTTP header.
#
# [*vhost_aliases*]
#   Array of other vhosts that assets should be served on at origin
#
# [*vhost_name*]
#   Primary vhost that assets should be served on at origin
#
class router::assets_origin(
  $asset_routes = {},
  $real_ip_header = '',
  $vhost_aliases = [],
  $vhost_name,
) {
  validate_array($vhost_aliases)

  $app_domain = hiera('app_domain')
  $enable_ssl = hiera('nginx_enable_ssl', true)

  # suspect we want `protected => false` here
  # once appropriate firewalling is in place?
  nginx::config::site { $vhost_name:
    content => template('router/assets_origin.conf.erb'),
  }

  nginx::config::ssl { $vhost_name:
    certtype => 'wildcard_publishing',
  }

  nginx::log {
    "${vhost_name}-json.event.access.log":
      json          => true,
      logstream     => present,
      statsd_metric => "${::fqdn_metrics}.nginx_logs.assets-origin.http_%{@fields.status}",
      statsd_timers => [{metric => "${::fqdn_metrics}.nginx_logs.assets-origin.time_request",
                          value => '@fields.request_time'}];
    "${vhost_name}-error.log":
      logstream => present;
  }
}

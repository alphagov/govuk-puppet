# = Class: router::assets_origin
#
# Configure vhost for serving external-facing assets.
#
# === Parameters
#
# [*asset_manager_uploaded_assets_routes*]
#   Hash of paths => vhost_names.  Each entry will be added as a route in the vhost
#
# [*whitehall_uploaded_assets_routes*]
#   Array of paths to proxy to whitehall-frontend.  Each entry will be added as a route in the vhost
#
# [*csv_preview_routes*]
#   Array of paths to proxy to the application rendering CSV Previews.  Each entry will be added as a route in the vhost.
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
# [*website_root*]
#   The URL to the root of the main GOV.UK host for redirects
#
class router::assets_origin(
  $asset_manager_uploaded_assets_routes = [],
  $whitehall_uploaded_assets_routes = [],
  $csv_preview_routes = [],
  $real_ip_header = '',
  $vhost_aliases = [],
  $vhost_name = 'assets-origin',
  $website_root = undef,
) {
  validate_array($vhost_aliases)

  $app_domain = hiera('app_domain_internal')
  $upstream_ssl = true

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
      statsd_metric => "${::fqdn_metrics}.nginx_logs.assets-origin.http_%{status}",
      statsd_timers => [{metric => "${::fqdn_metrics}.nginx_logs.assets-origin.time_request",
                          value => 'request_time'}];
    "${vhost_name}-error.log":
      logstream => present;
  }
}

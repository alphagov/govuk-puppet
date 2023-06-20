# = Class: router::draft_assets
#
# Configure vhost for serving draft assets.
#
# === Parameters
#
# [*real_ip_header*]
#   Uses the Nginx realip module (http://nginx.org/en/docs/http/ngx_http_realip_module.html)
#   to change the client IP address to the one in the specified HTTP header.
#
# [*vhost_name*]
#   Primary vhost for draft assets
#
# [*csv_preview_routes*]
#   Array of paths to proxy to the application rendering CSV Previews.  Each entry will be added as a route in the vhost.
#

class router::draft_assets(
  $real_ip_header = '',
  $vhost_name = 'draft-assets',
) {
  $whitehall_uploaded_assets_routes = hiera('router::assets_origin::whitehall_uploaded_assets_routes', [])
  $csv_preview_routes = hiera('router::assets_origin::csv_preview_routes', [])
  $asset_manager_uploaded_assets_routes = hiera('router::assets_origin::asset_manager_uploaded_assets_routes', [])
  $upstream_ssl = true
  $app_domain = hiera('app_domain_internal')

  nginx::config::site { $vhost_name:
    content => template('router/draft-assets.conf.erb'),
  }

  nginx::config::ssl { $vhost_name:
    certtype => 'wildcard_publishing',
  }
}

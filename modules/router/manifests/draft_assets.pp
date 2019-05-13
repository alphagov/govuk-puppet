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

class router::draft_assets(
  $real_ip_header = '',
  $vhost_name = 'draft-assets',
) {
  $enable_ssl = hiera('nginx_enable_ssl', true)
  $asset_manager_uploaded_assets_routes = hiera('router::assets_origin::asset_manager_uploaded_assets_routes', [])

  $app_domain = hiera('app_domain')

  if $::aws_migration {
    $upstream_ssl = true
  } else {
    $upstream_ssl = $enable_ssl
  }

  nginx::config::site { $vhost_name:
    content => template('router/draft-assets.conf.erb'),
  }

  nginx::config::ssl { $vhost_name:
    certtype => 'wildcard_publishing',
  }
}

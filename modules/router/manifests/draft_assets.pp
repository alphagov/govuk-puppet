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
  $asset_manager_uploaded_assets_routes = hiera('router::assets_origin::asset_manager_uploaded_assets_routes', [])

  $upstream_ssl = true

  if $::aws_environment == 'integration'{
    $app_domain = hiera('app_domain_internal')
  } else {
    $app_domain = hiera('app_domain')
  }

  nginx::config::site { $vhost_name:
    content => template('router/draft-assets.conf.erb'),
  }

  nginx::config::ssl { $vhost_name:
    certtype => 'wildcard_publishing',
  }
}

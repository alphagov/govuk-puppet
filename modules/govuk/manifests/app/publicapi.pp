# govuk::app::publicapi
#
# Definition used by both
# modules/govuk/manifests/apps/publicapi.pp
# and
# modules/govuk/manifests/apps/draft_publicapi.pp
#
# === Parameters
#
# [*privateapi_ssl*]
#   Boolean. Whether to use SSL for the private API.
#
# [*prefix*]
#   String. It specifies if it's the live publicapi or the draft publicapi (set
#   to '' for live, or to 'draft-' for draft).
#

define govuk::app::publicapi (
  $privateapi_ssl,
  $prefix,
) {
  $app_domain = hiera('app_domain')
  $app_name = "${prefix}publicapi"

  if $::aws_migration {
    # In AWS the upstream should use the internal domain. The nginx server_name
    # directive automatically gets assigned the internal domain by the
    # nginx::config::vhost::proxy defined type.
    $app_domain_internal = hiera('app_domain_internal')

    $whitehallapi = "whitehall-frontend.${app_domain_internal}"
    $rummager_api = "search.${app_domain_internal}"
    $content_store_api = "${prefix}content-store.${app_domain_internal}"

    $full_domain = $app_name
  } else {
    $whitehallapi = "whitehall-frontend.${app_domain}"
    $rummager_api = "search.${app_domain}"
    $content_store_api = "${prefix}content-store.${app_domain}"

    $full_domain = "${app_name}.${app_domain}"
  }

  if ($privateapi_ssl) {
    $privateapi_protocol = 'https'
  } else {
    $privateapi_protocol = 'http'
  }

  if ($::aws_environment == 'staging') or ($::aws_environment == 'production') {
    nginx::config::vhost::proxy { $full_domain:
      ensure           => absent,
      to               => [$whitehallapi, $content_store_api],
      to_ssl           => $privateapi_ssl,
      protected        => false,
      ssl_only         => false,
      extra_app_config => "
        # Don't proxy_pass / anywhere, just return 404. All real requests will
        # be handled by the location blocks below.
        return 404;
      ",
      extra_config     => template('govuk/publicapi_nginx_extra_config.erb'),
    }
  } else {
    nginx::config::vhost::proxy { $full_domain:
      ensure           => absent,
      to               => [$whitehallapi, $rummager_api, $content_store_api],
      to_ssl           => $privateapi_ssl,
      protected        => false,
      ssl_only         => false,
      extra_app_config => "
        # Don't proxy_pass / anywhere, just return 404. All real requests will
        # be handled by the location blocks below.
        return 404;
      ",
      extra_config     => template('govuk/publicapi_nginx_extra_config.erb'),
    }
  }
}

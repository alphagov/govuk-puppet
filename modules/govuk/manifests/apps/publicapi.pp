# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::publicapi (
  $backdrop_protocol = 'https',
  $backdrop_host = 'www.performance.service.gov.uk',
  $privateapi_ssl = true,
) {

  $app_domain = hiera('app_domain')
  $app_name = 'publicapi'

  if $::aws_migration {
    # In AWS the upstream should use the internal domain. The nginx server_name
    # directive automatically gets assigned the internal domain by the
    # nginx::config::vhost::proxy defined type.
    $app_domain_internal = hiera('app_domain_internal')

    $whitehallapi = "whitehall-frontend.${app_domain_internal}"
    $rummager_api = "search.${app_domain_internal}"
    # Content Store is always public
    $content_store_api = "content-store.${app_domain}"

    $full_domain = $app_name
  } else {
    $whitehallapi = "whitehall-frontend.${app_domain}"
    $rummager_api = "search.${app_domain}"
    $content_store_api = "content-store.${app_domain}"

    $full_domain = "${app_name}.${app_domain}"
  }

  $backdrop_url = "${backdrop_protocol}://${backdrop_host}"

  if ($privateapi_ssl) {
    $privateapi_protocol = 'https'
  } else {
    $privateapi_protocol = 'http'
  }

  nginx::config::vhost::proxy { $full_domain:
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

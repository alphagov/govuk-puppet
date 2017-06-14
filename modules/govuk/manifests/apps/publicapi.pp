# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::publicapi (
  $backdrop_protocol = 'https',
  $backdrop_host = 'www.performance.service.gov.uk',
  $privateapi_ssl = true,
) {

  $app_domain = hiera('app_domain')

  $whitehallapi = "whitehall-frontend.${app_domain}"
  $rummager_api = "search.${app_domain}"
  $content_store_api = "content-store.${app_domain}"

  $backdrop_url = "${backdrop_protocol}://${backdrop_host}"

  if ($privateapi_ssl) {
    $privateapi_protocol = 'https'
  } else {
    $privateapi_protocol = 'http'
  }

  $app_name = 'publicapi'
  $full_domain = "${app_name}.${app_domain}"

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

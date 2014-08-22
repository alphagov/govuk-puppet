# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::limelight(
  $port = 3040,
  $vhost_protected,
  $limelight_proxy_performance_api = false
) {

  if $limelight_proxy_performance_api {
    $app_domain = hiera('app_domain')
    $publicapi_domain = "publicapi.${app_domain}"

    $nginx_extra_config = "
      location ~ ^/performance/[^/]+/api {
        proxy_set_header Host ${publicapi_domain};
        proxy_pass https://${publicapi_domain};
      }"
  } else {
    $nginx_extra_config = ''
  }

  govuk::app { 'limelight':
    app_type              => 'rack',
    port                  => $port,
    vhost_protected       => $vhost_protected,
    nginx_extra_config    => $nginx_extra_config,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'limelight',
  }
}


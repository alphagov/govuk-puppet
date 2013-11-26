class govuk::apps::limelight(
  $port = 3040,
  $vhost_protected
) {

  $limelight_proxy_performance_api = str2bool(extlookup('limelight_proxy_performance_api', 'no'))

  if $limelight_proxy_performance_api {
    $app_domain = extlookup('app_domain')
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
    app_type           => 'rack',
    port               => $port,
    vhost_protected    => $vhost_protected,
    nginx_extra_config => $nginx_extra_config
  }
}


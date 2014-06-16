class govuk::apps::collections(
  $port = 3070,
  $vhost_protected,
  $proxy_content_api = false,
) {
  $app_domain = hiera('app_domain')

  validate_bool($proxy_content_api)
  if ($proxy_content_api) {
    # So that AJAX requests are handled by the same application in development as production
    $nginx_extra_config = "
      location /api {
        rewrite ^/api/?(.*) /\$1 break;
        proxy_set_header Host 'contentapi.${app_domain}';
        proxy_pass http://contentapi.${app_domain};
      }
    "
  } else {
    $nginx_extra_config = ''
  }

  govuk::app { 'collections':
    app_type              => 'rack',
    port                  => $port,
    vhost_protected       => $vhost_protected,
    health_check_path     => '/oil-and-gas',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'collections',
    nginx_extra_config    => $nginx_extra_config,
  }
}

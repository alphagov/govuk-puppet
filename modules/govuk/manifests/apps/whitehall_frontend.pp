class govuk::apps::whitehall_frontend( $port = 3020 ) {

  $vhost_suffix = extlookup('app_domain')

  $asset_config_in_platform = $::govuk_platform ? {
    "development" => "
      proxy_set_header Host 'whitehall-admin.${vhost_suffix}';
      proxy_pass http://whitehall-admin.${vhost_suffix};
    ",
    default => "
      expires max;
      add_header Cache-Control public;
    ",
  }

  govuk::app { 'whitehall-frontend':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/healthcheck',
    nginx_extra_config => "
      location /government/admin {
        rewrite ^ https://whitehall-admin.${vhost_suffix}\$request_uri? permanent;
      }
      location /government/assets {
        ${asset_config_in_platform}
      }
      location /government/uploads {
        proxy_set_header Host 'whitehall-admin.${vhost_suffix}';
        proxy_pass http://whitehall-admin.${vhost_suffix};
      }
    ",
  }
}

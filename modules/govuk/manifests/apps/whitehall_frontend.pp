class govuk::apps::whitehall_frontend( $port = 3020 ) {

  $vhost_suffix = extlookup('app_domain_suffix', 'dev.gov.uk')

  govuk::app { 'whitehall-frontend':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/healthcheck',
    nginx_extra_config => "
      location /government/admin {
        rewrite ^ https://whitehall-admin.${vhost_suffix}\$request_uri? permanent;
      }
      location /government/assets {
        expires max;
        add_header Cache-Control public;
      }
      location /government/uploads {
        proxy_set_header Host 'whitehall-admin.${vhost_suffix}';
        proxy_pass http://whitehall-admin.${vhost_suffix};
      }
    ",
  }
}

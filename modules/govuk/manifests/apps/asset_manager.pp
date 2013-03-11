class govuk::apps::asset_manager( $port = 3037 ) {
  include assets
  include clamav

  govuk::app { 'asset-manager':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    nginx_extra_config => '
    client_max_body_size 500m;

    proxy_set_header X-Sendfile-Type X-Accel-Redirect;
    proxy_set_header X-Accel-Mapping /var/apps/asset-manager/uploads/assets/=/raw/;

    # /raw/(.*) is the path mapping sent from the rails application to
    # nginx and is immediately picked up. /raw/(.*) is not available
    # publicly as it is an internal path mapping.
    location ~ /raw/(.*) {
      internal;
      alias /var/apps/asset-manager/uploads/assets/$1;
    }'
  }

  govuk::delayed_job::worker { 'asset-manager': }

}

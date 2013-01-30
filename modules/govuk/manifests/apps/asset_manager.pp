class govuk::apps::asset_manager( $port = 3037 ) {
  govuk::app { 'asset-manager':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/',
  }
}

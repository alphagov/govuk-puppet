class govuk::apps::search_admin( $port = 3073 ) {
  govuk::app { 'search-admin':
    app_type               => 'rack',
    port                   => $port,
    vhost_ssl_only         => true,
    health_check_path      => '/best-bets',
    log_format_is_json     => true,
    asset_pipeline         => true,
    deny_framing           => true,
  }
}

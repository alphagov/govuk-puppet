class govuk::apps::contacts_frontend (
  $port = 3074,
  $vhost_protected
) {
  govuk::app { 'contacts-frontend':
    app_type              => 'rack',
    port                  => $port,
    vhost_protected       => $vhost_protected,
    health_check_path     => '/healthcheck',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'contacts-frontend',
  }
}

class govuk::apps::contacts(
  $vhost = 'contacts',
  $port = 3051,
  $vhost_protected = undef,
) {

  govuk::app { 'contacts':
    app_type              => 'rack',
    vhost                 => $vhost,
    port                  => $port,
    health_check_path     => '/healthcheck',
    vhost_protected       => $vhost_protected,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'contacts-assets',
  }
}

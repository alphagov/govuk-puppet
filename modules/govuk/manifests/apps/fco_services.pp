class govuk::apps::fco_services(
  $port = 3050,
  $vhost_protected,
  $vhost_aliases = []
) {

  govuk::app { 'fco-services':
    app_type           => 'rack',
    port               => $port,
    vhost_protected    => $vhost_protected,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    vhost_aliases      => $vhost_aliases,
    asset_pipeline     => true,
    deny_framing       => true,
  }
}

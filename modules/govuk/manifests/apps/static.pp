# govuk::apps::static
#
# The GOV.UK static application -- serves static assets and templates
class govuk::apps::static( $port = 3013 ) {
  $app_domain = extlookup('app_domain')
  $website_root = extlookup('website_root')
  $asset_manager_host = "asset-manager.${app_domain}"

  govuk::app { 'static':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/templates/wrapper.html.erb',
    log_format_is_json    => hiera('govuk_leverage_json_app_log', false),
    nginx_extra_config    => template('govuk/static_extra_nginx_config.conf.erb'),
    asset_pipeline        => true,
    asset_pipeline_prefix => 'static',
  }
}

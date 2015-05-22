# govuk::apps::static
#
# The GOV.UK static application -- serves static assets and templates
#
# === Parameters
#
# [*global_header_text*]
#   A string to display in the header instead of "GOV.UK". Used for the draft
#   environment.
#   Default: ''
#
class govuk::apps::static(
  $port = 3013,
  $global_header_text = ''
) {
  $app_domain = hiera('app_domain')
  $website_root = hiera('website_root')
  $asset_manager_host = "asset-manager.${app_domain}"
  $enable_ssl = hiera('nginx_enable_ssl', true)

  govuk::app { 'static':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/templates/wrapper.html.erb',
    log_format_is_json    => true,
    nginx_extra_config    => template('govuk/static_extra_nginx_config.conf.erb'),
    asset_pipeline        => true,
    asset_pipeline_prefix => 'static',
  }

  Govuk::App::Envvar {
    app => 'static',
  }

  govuk::app::envvar {
    "${title}-GLOBAL_HEADER_TEXT":
      varname => 'GLOBAL_HEADER_TEXT',
      value   => $global_header_text;
  }
}

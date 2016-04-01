# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define govuk::app::nginx_vhost (
  $vhost,
  $app_port,
  $aliases = [],
  $protected = false,
  $protected_location = '/',
  $ssl_only = false,
  $logstream = present,
  $nginx_extra_config = '',
  $nginx_extra_app_config = '',
  $intercept_errors = false,
  $deny_framing = false,
  $is_default_vhost = false,
  $asset_pipeline = false,
  $asset_pipeline_prefix = 'assets',
  $hidden_paths = undef,
  $single_page_app = false,
  $read_timeout = 15,
  $ensure = 'present',
  $alert_5xx_warning_rate = 0.05,
  $alert_5xx_critical_rate = 0.1,
) {

  # added to whitelist in lib/puppet-lint/plugins/check_hiera.rb
  # this is necessary because it is a global override in a defined type
  $global_asset_pipeline_enabled = hiera('govuk::app::nginx_vhost::asset_pipeline_enabled', true)
  validate_bool($global_asset_pipeline_enabled)

  # Force asset_pipeline support off on development VMs
  # in development, asset requests need to be passed through to the app
  # we also don't want to be setting cache-control headers.
  if $asset_pipeline and $global_asset_pipeline_enabled {
    $nginx_extra_config_real = template('govuk/asset_pipeline_extra_nginx_conf.erb')
  } else {
    $nginx_extra_config_real = $nginx_extra_config
  }

  nginx::config::vhost::proxy { $vhost:
    ensure                  => $ensure,
    to                      => ["localhost:${app_port}"],
    aliases                 => $aliases,
    protected               => $protected,
    protected_location      => $protected_location,
    ssl_only                => $ssl_only,
    logstream               => $logstream,
    extra_config            => $nginx_extra_config_real,
    extra_app_config        => $nginx_extra_app_config,
    intercept_errors        => $intercept_errors,
    deny_framing            => $deny_framing,
    is_default_vhost        => $is_default_vhost,
    hidden_paths            => $hidden_paths,
    single_page_app         => $single_page_app,
    read_timeout            => $read_timeout,
    alert_5xx_warning_rate  => $alert_5xx_warning_rate,
    alert_5xx_critical_rate => $alert_5xx_critical_rate,
  }
}

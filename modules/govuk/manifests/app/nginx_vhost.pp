# == Define: govuk::app::nginx_vhost
#
# Sets up an nginx vhost which proxies to an application
#
# === Parameters
#
# [*vhost*]
#   Title of the vhost
#
# [*app_port*]
#   Port the app runs on
#
# [*custom_http_host*]
#   This setting allows the default HTTP Host header to be overridden.
#
#   An example of where this is useful is if requests are handled by different
#   backend applications but use the same hostname.
#   Default: undef
#
# [*aliases*]
#   Other hostnames to serve the app on
#
# [*protected*]
#   Boolean, whether basic auth should be enabled for this app
#
# [*protected_location*]
#   Prefix path to protect with basic auth, defaults to everything
#
# [*ssl_only*]
#   Whether the app should only be available on a secure connection
#
# [*logstream*]
#   Whether nginx logs should be shipped to the logging box
#
# [*nginx_extra_config*]
#   A string containing additional nginx config
#
# [*nginx_extra_app_config*]
#   A string containing additional nginx config for the `app` location block
#
# [*intercept_errors*]
#   Boolean, whether to set nginx's `proxy_intercept_errors`
#
# [*deny_framing*]
#   Boolean, whether nginx should instruct browsers to not allow framing the page
#
# [*is_default_vhost*]
#   Boolean, whether to set `default_server` in nginx
#
# [*asset_pipeline*]
#   Boolean, whether to enable the Rails asset pipeline
#
# [*asset_pipeline_prefix*]
#   Path that nginx will serve assets from
#
# [*hidden_paths*]
#   Array of paths that nginx will force to return an error
#
# [*single_page_app*]
#   String, if set the vhost will attempt to serve files from this directory
#
# [*read_timeout*]
#   Number of seconds the vhost will wait for a response before timing out
#
# [*ensure*]
#   Whether to create the nginx vhost, present/absent
#
# [*alert_5xx_warning_rate*]
#   The error percentage that triggers a warning alert
#
# [*alert_5xx_critical_rate*]
#   The error percentage that triggers a critical alert
#
# [*proxy_http_version_1_1_enabled*]
#   Boolean, whether to enable HTTP/1.1 for proxying from the Nginx vhost
#   to the app server.
#
define govuk::app::nginx_vhost (
  $vhost,
  $app_port,
  $custom_http_host = undef,
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
  $proxy_http_version_1_1_enabled = false,
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
    ensure                         => $ensure,
    to                             => ["localhost:${app_port}"],
    aliases                        => $aliases,
    protected                      => $protected,
    protected_location             => $protected_location,
    ssl_only                       => $ssl_only,
    logstream                      => $logstream,
    extra_config                   => $nginx_extra_config_real,
    extra_app_config               => $nginx_extra_app_config,
    intercept_errors               => $intercept_errors,
    deny_framing                   => $deny_framing,
    custom_http_host               => $custom_http_host,
    is_default_vhost               => $is_default_vhost,
    hidden_paths                   => $hidden_paths,
    single_page_app                => $single_page_app,
    read_timeout                   => $read_timeout,
    alert_5xx_warning_rate         => $alert_5xx_warning_rate,
    alert_5xx_critical_rate        => $alert_5xx_critical_rate,
    proxy_http_version_1_1_enabled => $proxy_http_version_1_1_enabled,
  }
}

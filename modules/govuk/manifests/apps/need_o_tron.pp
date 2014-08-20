# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::need_o_tron(
  $port = '3004',
  $needotron_intercept_errors = true
) {
  govuk::app { 'needotron':
    app_type          => 'rack',
    vhost_ssl_only    => true,
    port              => $port,
    health_check_path => '/',
    intercept_errors  => $needotron_intercept_errors,
    asset_pipeline    => true,
  }
}

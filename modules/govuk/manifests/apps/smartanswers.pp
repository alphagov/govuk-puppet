# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::smartanswers(
  $port = 3010,
) {
  govuk::app { 'smartanswers':
    app_type              => 'rack',
    port                  => $port,
    health_check_path     => '/pay-leave-for-parents',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'smartanswers',
  }
}

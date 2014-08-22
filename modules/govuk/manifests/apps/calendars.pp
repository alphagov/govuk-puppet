# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::calendars(
  $port = 3011,
  $vhost_protected
) {
  govuk::app { 'calendars':
    app_type              => 'rack',
    port                  => $port,
    vhost_protected       => $vhost_protected,
    health_check_path     => '/bank-holidays',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'calendars',
  }
}

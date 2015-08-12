# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::content_planner(
  $enabled = true,
  $port = 3058,
) {
  if $enabled {
    govuk::app { 'content-planner':
      ensure             => absent,
      app_type           => 'rack',
      port               => $port,
      health_check_path  => '/healthcheck',
      deny_framing       => true,
      log_format_is_json => true,
    }
  }
}

# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::finder_api(
  $port = 3063,
  $enabled = false,
) {

  if str2bool($enabled) {
    govuk::app { 'finder-api':
      app_type           => 'rack',
      port               => $port,
      health_check_path  => '/finders/cma-cases/schema.json',
      log_format_is_json => true,
    }
  }
}

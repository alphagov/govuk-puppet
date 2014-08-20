# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::specialist_publisher(
  $port = 3064,
  $vhost_protected = false,
  $enabled = false,
  $enable_procfile_worker = true,
) {

  if str2bool($enabled) {
    govuk::app { 'specialist-publisher':
      app_type           => 'rack',
      port               => $port,
      vhost_protected    => $vhost_protected,
      health_check_path  => '/specialist-documents',
      log_format_is_json => true,
    }

    govuk::procfile::worker { 'specialist-publisher':
      enable_service => $enable_procfile_worker,
    }
  }
}

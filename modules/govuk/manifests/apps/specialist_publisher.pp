# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::specialist_publisher(
  $port = '3064',
  $enabled = false,
  $enable_procfile_worker = true,
) {

  if $enabled {
    govuk::app { 'specialist-publisher':
      app_type           => 'rack',
      port               => $port,
      health_check_path  => '/specialist-documents',
      log_format_is_json => true,
      nginx_extra_config => '
client_max_body_size 500m;
',
    }

    govuk::procfile::worker { 'specialist-publisher':
      enable_service => $enable_procfile_worker,
    }
  }
}

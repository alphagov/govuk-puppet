# == Class: govuk::apps::entity_extractor
#
# Service for extracting named entities from text
#
# === Parameters
#
# [*port*]
#   The port that entity-extractor service listens on.
#   Default: 3096
#
class govuk::apps::entity_extractor(
  $enabled = false,
  $port = 3096,
) {
  if $enabled {
    $app_name = 'entity-extractor'
    govuk::app { $app_name:
      app_type           => 'bare',
      log_format_is_json => true,
      port               => $port,
      command            => "./${app_name}",
      health_check_path  => '/healthcheck',
      vhost_ssl_only     => true,
    }
  }
}

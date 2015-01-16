# == Class: govuk::apps::entity_extractor
#
# Service for extracting named entities from text
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3096
#
# [*vhost*]
#   The primary vhost for the application.  This is necessary to allow this to
#   be overridden on the dev VM where both this and the content-store are on
#   the same machine (content-store currently has a vhost alias of
#   publishing-api).  Once this has implemented the full API, content-store's
#   alias will be repointed here, and this param will no longer be needed.
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

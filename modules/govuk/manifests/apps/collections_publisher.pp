# == Class: govuk::apps::collections_publisher
#
# Publishes certain collection and tag formats requiring
# complicated UIs.
#
# === Parameters
#
# [*panopticon_bearer_token*]
#   The bearer token to use when communicating with Panopticon.
#   Default: example
# [*port*]
#   The port that publishing API is served on.
#   Default: 3078
#
class govuk::apps::collections_publisher(
  $panopticon_bearer_token = 'example',
  $port = 3078,
) {

  govuk::app::envvar { "${title}-PANOPTICON_BEARER_TOKEN":
    app     => 'collections-publisher',
    varname => 'PANOPTICON_BEARER_TOKEN',
    value   => $panopticon_bearer_token,
  }

  govuk::app { 'collections-publisher':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }
}

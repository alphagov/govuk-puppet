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
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3078
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::collections_publisher(
  $panopticon_bearer_token = 'example',
  $port = '3078',
  $enable_procfile_worker = true,
  $publishing_api_bearer_token = undef,
  $redis_host = 'redis-1.backend',
  $redis_port = '6379',
) {

  govuk::app { 'collections-publisher':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }

  Govuk::App::Envvar {
    app =>  'collections-publisher',
  }

  govuk::app::envvar {
    "${title}-PANOPTICON_BEARER_TOKEN":
      varname => 'PANOPTICON_BEARER_TOKEN',
      value   => $panopticon_bearer_token;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-REDIS_HOST":
      varname => 'REDIS_HOST',
      value   => $redis_host;
    "${title}-REDIS_PORT":
      varname => 'REDIS_PORT',
      value   => $redis_port;
  }

  govuk::procfile::worker {'collections-publisher':
    enable_service => $enable_procfile_worker,
  }
}

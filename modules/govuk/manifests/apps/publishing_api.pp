# == Class: govuk::apps::publishing_api
#
# An application to route requests between multiple content-store
# endpoints based on whether they're live or in other states.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3093
#
# [*content_store*]
#   Is a URL that tells publishing API which content store to save
#   published content in.
#
# [*draft_content_store*]
#   Is a URL that tells publishing API which content store to save
#   draft content in.
#
# [*suppress_draft_store_502_error*]
#   Suppresses "502 Bad Gateway" returned by nginx when publishing API
#   attempts to store draft content. This is intended to be used only
#   during development so that we're not forced to keep draft content
#   store running while testing unrelated features.
#   Default: false
#
class govuk::apps::publishing_api(
  $port = 3093,
  $content_store = '',
  $draft_content_store = '',
  $suppress_draft_store_502_error = false,
) {
  $app_name = 'publishing-api'
  govuk::app { $app_name:
    app_type           => 'bare',
    log_format_is_json => true,
    port               => $port,
    command            => "./${app_name}",
    health_check_path  => '/healthcheck',
    vhost_ssl_only     => true,
  }

  govuk::logstream { "${app_name}-app-out":
    ensure  => present,
    logfile => "/var/log/${app_name}/app.out.log",
    tags    => ['stdout', 'app'],
    json    => true,
    fields  => {'application' => $app_name},
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    'CONTENT_STORE':
      value => $content_store;
    'DRAFT_CONTENT_STORE':
      value => $draft_content_store;
    'SUPPRESS_DRAFT_STORE_502_ERROR':
      value => $suppress_draft_store_502_error;
  }
}

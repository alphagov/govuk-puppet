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
class govuk::apps::publishing_api(
  $port = 3093,
  $content_store = '',
  $draft_content_store = '',
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
  }
}

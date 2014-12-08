# == Class: govuk::apps::publishing_api
#
# An application to route requests between multiple content-store
# endpoints based on whether they're live or in other states.
#
class govuk::apps::publishing_api(
  $enabled = false,
  $port = 3093
) {
  if $enabled {
    $app_name = 'publishing-api'

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar {
      'PORT': value => $port;
    }

    govuk::app { $app_name:
      app_type           => 'bare',
      log_format_is_json => true,
      port               => $port,
      command            => "./${app_name}",
      health_check_path  => '/healthcheck',
    }
  }
}

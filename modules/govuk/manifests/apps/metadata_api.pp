# == Class: govuk::apps::metadata_api
#
class govuk::apps::metadata_api (
  # The default port that the application will start on.
  $port = 3086,
) {
  $app_name = 'metadata-api'

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    'HTTP_PORT': value => $port;
  }

  govuk::app { $app_name:
    app_type           => 'bare',
    log_format_is_json => true,
    port               => $port,
    command            => "./${app_name}",
    health_check_path  => '/healthcheck',
  }
}

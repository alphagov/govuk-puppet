# == Class: govuk::apps::backdrop_read
#
# backdrop_read is the read component of the Performance Platform
# API.
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
# [*signon_api_user_token*]
#   An API token to allow backdrop-read to communicate with the performanceplatform-admin
#   app via Signon
#
class govuk::apps::backdrop_read (
  $enabled = true,
  $signon_api_user_token = undef,
) {
  if $enabled {
    $app_name = 'backdrop-read'
    $port = '3101'

    govuk::app { $app_name:
      app_type           => 'bare',
      port               => $port,
      command            => "./venv/bin/gunicorn backdrop.read.api:app --bind 127.0.0.1:${port} --workers 4 --timeout 30",
      vhost_ssl_only     => true,
      health_check_path  => '/_status',
      log_format_is_json => true,
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar {
      "${title}-SIGNON_API_USER_TOKEN":
        varname => 'SIGNON_API_USER_TOKEN',
        value   => $signon_api_user_token;
    }
  }
}

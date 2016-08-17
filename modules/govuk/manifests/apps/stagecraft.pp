# == Class: govuk::apps::stagecraft
#
# Stagecraft is the API service for the Performance Platform.
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
# [*database_password*]
#   The password for the app to connect to its database
#
# [*message_queue_password*]
#   The password for the app to connect to its message queue
#
class govuk::apps::stagecraft (
  $enabled = false,
  $database_password = undef,
  $message_queue_password = undef,
) {
  $app_name = 'stagecraft'

  if $enabled {

    include libffi

    $port = '3103'

    govuk::app { $app_name:
      app_type           => 'bare',
      port               => 3103,
      command            => "./venv/bin/gunicorn stagecraft.wsgi:application --bind 127.0.0.1:${port} --workers 4",
      vhost_ssl_only     => true,
      health_check_path  => '/_status',
      log_format_is_json => true;
    }
    govuk_logging::logstream { 'performanceplatform_collectors_log':
      logfile => '/var/apps/stagecraft/log/collectors.json.log',
      fields  => {'application' => 'performanceplatform-collectors'},
      json    => true,
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar {
      "${title}-DATABASE_PASSWORD":
        varname => 'DATABASE_PASSWORD',
        value   => $database_password;
      "${title}-MESSAGE_QUEUE_PASSWORD":
        varname => 'MESSAGE_QUEUE_PASSWORD',
        value   => $message_queue_password;
    }
  }
}

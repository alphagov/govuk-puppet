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
  $fernet_key = undef,
  $fernet_use_hkdf = undef,
) {
  $app_name = 'stagecraft'

  if $enabled {

    ensure_packages(['libffi-dev'])

    $port = '3103'

    govuk::app { $app_name:
      ensure             => 'absent',
      app_type           => 'bare',
      port               => 3103,
      command            => "./venv/bin/gunicorn stagecraft.wsgi:application --bind 127.0.0.1:${port} --workers 4",
      vhost_ssl_only     => true,
      health_check_path  => '/_status',
      log_format_is_json => true;
    }

    @filebeat::prospector { 'performanceplatform_collectors_log':
      ensure => 'absent',
      paths  => ['/var/apps/stagecraft/log/collectors.json.log'],
      fields => {'application' => 'performanceplatform-collectors'},
      json   => {'add_error_key' => true},
    }

    Govuk::App::Envvar {
      app    => $app_name,
      ensure => 'absent',
    }

    govuk::app::envvar {
      "${title}-DATABASE_PASSWORD":
        varname => 'DATABASE_PASSWORD',
        value   => $database_password;
      "${title}-MESSAGE_QUEUE_PASSWORD":
        varname => 'MESSAGE_QUEUE_PASSWORD',
        value   => $message_queue_password;
      "${title}-FERNET_USE_HKDF":
        varname => 'FERNET_USE_HKDF',
        value   => $fernet_use_hkdf;
      "${title}-FERNET_KEY":
        varname => 'FERNET_KEY',
        value   => $fernet_key;
    }
  }
}

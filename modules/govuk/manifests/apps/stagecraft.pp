# == Class: govuk::apps::stagecraft
#
# Stagecraft is the API service for the Performance Platform.
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
class govuk::apps::stagecraft (
  $enabled = false,
) {
  if $enabled {

    include libffi

    $port = '3103'

    govuk::app { 'stagecraft':
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
  }
}

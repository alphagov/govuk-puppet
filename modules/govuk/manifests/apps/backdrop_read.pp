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
class govuk::apps::backdrop_read (
  $enabled = true,
) {
  if $enabled {
    $port = '3101'

    govuk::app { 'backdrop-read':
      app_type           => 'bare',
      port               => $port,
      command            => "./venv/bin/gunicorn backdrop.read.api:app --bind 127.0.0.1:${port} --workers 4 --timeout 30",
      vhost_ssl_only     => true,
      health_check_path  => '/_status',
      log_format_is_json => true,
    }
  }
}

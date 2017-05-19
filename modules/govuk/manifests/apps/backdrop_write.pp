# == Class: govuk::apps::backdrop_write
#
# backdrop_write is the write component of the Performance Platform
# API.
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker. Typically sued to disable the worker
#   on the dev VM.
#
class govuk::apps::backdrop_write (
  $enabled = true,
  $enable_procfile_worker = true,
) {
  if $enabled {
    $port = '3102'

    govuk::app { 'backdrop-write':
      app_type           => 'bare',
      port               => $port,
      command            => "./venv/bin/gunicorn backdrop.write.api:app --bind 127.0.0.1:${port} --workers 4 --timeout 60",
      vhost_ssl_only     => true,
      health_check_path  => '/_status',
      nginx_extra_config => 'client_max_body_size 50m;',
      read_timeout       => 60,
      log_format_is_json => true,
    }

    govuk::procfile::worker { 'backdrop-transformer':
      setenv_as      => 'backdrop-write',
      enable_service => $enable_procfile_worker,
    }
  }
}

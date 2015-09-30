# == Class: govuk::apps::performanceplatform_admin
#
# Performance Platform Admin is the admin interface to create dashboards on
# the Performance Platform and upload data to Backdrop.
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
class govuk::apps::performanceplatform_admin (
  $enabled = false,
) {
  if $enabled {
    $port = '3104'

    include libffi

    govuk::app { 'performanceplatform-admin':
      app_type           => 'bare',
      port               => $port,
      command            => "./venv/bin/gunicorn application:app --bind 127.0.0.1:${port} --workers 4",
      vhost_ssl_only     => true,
      health_check_path  => '/_status',
      log_format_is_json => true,
    }
  }
}

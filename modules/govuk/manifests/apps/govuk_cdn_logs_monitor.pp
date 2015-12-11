# == Class: govuk::apps::govuk_cdn_logs_monitor
#
# CDN logs monitor listens to the web activity logs being streamed
# from the CDN and processes them to identify problems with the site.
#
# Read more: https://github.com/alphagov/govuk-cdn-logs-monitor
#
# === Parameters
#
# [*enabled*]
#   Whether the app should exist
#   Default: false
#
# [*cdn_log_dir*]
#   Full path of the directory that cdn logs are written to
#   Default: /mnt/logs_cdn
#
# [*processed_data_dir*]
#   Directory that processed data from the logs is stored in
#   Default: processed
#
class govuk::apps::govuk_cdn_logs_monitor (
  $enabled = true,
  $cdn_log_dir = '/mnt/logs_cdn',
  $processed_data_dir = '/mnt/logs_cdn_processed/data',
) {
  if $enabled {
    Govuk::App::Envvar {
      app => 'govuk-cdn-logs-monitor',
    }

    govuk::app::envvar {
      'GOVUK_CDN_LOG_DIR':
        value => $cdn_log_dir;
      'GOVUK_PROCESSED_DATA_DIR':
        value => $processed_data_dir;
    }

    govuk::app { 'govuk-cdn-logs-monitor':
      app_type           => 'bare',
      command            => 'bundle exec ruby scripts/monitor_logs.rb',
      enable_nginx_vhost => false
    }
  }
}

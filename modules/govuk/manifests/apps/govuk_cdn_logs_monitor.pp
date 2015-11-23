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
# [*cdn_log_filename*]
#   Name of the file that cdn logs are written to
#   Default: cdn-govuk.log
#
# [*processed_data_dir*]
#   Directory that processed data from the logs is stored in
#   Default: processed
#
# [*good_urls_file*]
#   Name of file that known good urls are stored in
#   Default: good_urls.csv
#
class govuk::apps::govuk_cdn_logs_monitor (
  $enabled = true,
  $cdn_log_dir = '/mnt/logs_cdn',
  $cdn_log_filename = 'cdn-govuk.log',
  $processed_data_dir = 'processed',
  $good_urls_file = 'good_urls.csv',
) {
  if $enabled {
    $cdn_log_file_full_path = "${cdn_log_dir}/${cdn_log_filename}"
    $good_urls_full_path = "${processed_data_dir}/${good_urls_file}"

    Govuk::App::Envvar {
      app => 'govuk-cdn-logs-monitor',
    }

    govuk::app::envvar {
      'GOVUK_CDN_LOG_DIR':
        value => $cdn_log_dir;
      'GOVUK_CDN_LOG_FILE':
        value => $cdn_log_file_full_path;
      'GOVUK_PROCESSED_DATA_DIR':
        value => $processed_data_dir;
      'GOVUK_GOOD_URLS_FILE':
        value => $good_urls_full_path;
    }

    govuk::app { 'govuk-cdn-logs-monitor':
      app_type           => 'bare',
      command            => './process_404s.sh',
      enable_nginx_vhost => false
    }
  }
}

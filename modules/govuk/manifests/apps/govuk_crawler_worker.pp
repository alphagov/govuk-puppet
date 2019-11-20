# == Class: govuk::apps::govuk_crawler_worker
#
# Sets up the GOV.UK Crawler Worker app.
# https://github.com/alphagov/govuk_crawler_worker
#
# === Parameters
#
# [*amqp_pass*]
#   Password for the app to use to connect to a message queue exchange
#
# [*blacklist_paths*]
#   A list of paths that the crawler worker should not crawl
#
# [*crawler_threads*]
#   The number of threads for the crawler worker
#   Type: Integer in string format
#   Default: '4'
#
# [*enabled*]
#   Whether the app should be enabled
#
# [*mirror_root*]
#   The path on disk where the crawler should save files to
#
# [*port*]
#   The port the app listens on
#
# [*root_urls*]
#   A list of hostnames that the crawler should crawl
#
# [*rate_limit_token*]
#   Sets the header "Rate-Limit-Token" which ensures that the crawler is
#   whitelisted by the rate limiting function (receiving 429 status)
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
# [*disable_during_data_sync*]
#   Whether to disable the crawler worker while the data sync is happening
#   during the night.
#
class govuk::apps::govuk_crawler_worker (
  $amqp_host = 'localhost',
  $amqp_pass = 'guest',
  $blacklist_paths = [],
  $crawler_threads = '4',
  $enabled   = false,
  $mirror_root = '/mnt/crawler_worker',
  $port = '3074',
  $root_urls = [],
  $rate_limit_token = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $disable_during_data_sync = false,
) {
  validate_array($blacklist_paths, $root_urls)

  $app_name = 'govuk_crawler_worker'

  if $enabled {
    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar {
      'AMQP_ADDRESS':
        value => "amqp://govuk_crawler_worker:${amqp_pass}@${amqp_host}:5672/";
      'AMQP_EXCHANGE':
        value => 'govuk_crawler_exchange';
      'AMQP_MESSAGE_QUEUE':
        value => 'govuk_crawler_queue';
      'BLACKLIST_PATHS':
        value => join($blacklist_paths, ',');
      'CRAWLER_THREADS':
        value => $crawler_threads;
      'HTTP_PORT':
        value => $port;
      'REDIS_ADDRESS':
        value => '127.0.0.1:6379';
      'REDIS_KEY_PREFIX':
        value => 'gcw';
      'ROOT_URLS':
        value => join($root_urls, ',');
      'MIRROR_ROOT':
        value => $mirror_root;
      'TTL_EXPIRE_TIME':
        value => '24h';
      'RATE_LIMIT_TOKEN':
        value => $rate_limit_token;
    }

    file { $mirror_root:
      ensure => directory,
      mode   => '0755',
      owner  => 'deploy',
      group  => 'deploy',
    }

    if $disable_during_data_sync and $::data_sync_in_progress {
      $service_ensure = stopped
    } else {
      $service_ensure = running
    }

    $app_check_period = $disable_during_data_sync ? {
      true    => 'not_data_sync',
      default => '24x7',
    }

    govuk::app { $app_name:
      app_type               => 'bare',
      log_format_is_json     => true,
      port                   => $port,
      command                => './govuk_crawler_worker -json',
      health_check_path      => '/healthcheck',
      check_period           => $app_check_period,
      nagios_memory_warning  => $nagios_memory_warning,
      nagios_memory_critical => $nagios_memory_critical,
      ensure_service         => $service_ensure,
    }

    include govuk::apps::govuk_crawler_worker::rabbitmq

    if $disable_during_data_sync {
      govuk_data_sync_in_progress { $app_name:
        start_command  => "sudo initctl stop ${app_name}",
        finish_command => "sudo initctl start ${app_name}",
        require        => Govuk::App::Service[$app_name],
      }
    }
  }
}

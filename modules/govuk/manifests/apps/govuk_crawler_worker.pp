# == Class: govuk::apps::govuk_crawler_worker
#
# Sets up the GOV.UK Crawler Worker app.
# https://github.com/alphagov/govuk_crawler_worker
#
# === Parameters
#
# [*airbrake_api_key*]
#   API key to use to connect to the exception notification service
#
# [*airbrake_endpoint*]
#   Location to send exception notifications to over HTTP
#
# [*airbrake_env*]
#   Environment to set for exception notification
#
# [*amqp_pass*]
#   Password for the app to use to connect to a message queue exchange
#
# [*blacklist_paths*]
#   A list of paths that the crawler worker should not crawl
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
class govuk::apps::govuk_crawler_worker (
  $airbrake_api_key = '',
  $airbrake_endpoint = '',
  $airbrake_env = '',
  $amqp_pass = 'guest',
  $blacklist_paths = [],
  $enabled   = false,
  $mirror_root = '/mnt/crawler_worker',
  $port = '3074',
) {
  validate_array($blacklist_paths)

  if $enabled {
    Govuk::App::Envvar {
      app => 'govuk_crawler_worker',
    }

    govuk::app::envvar {
      'AIRBRAKE_API_KEY':
        value => $airbrake_api_key;
      'AIRBRAKE_ENDPOINT':
        value => $airbrake_endpoint;
      'AIRBRAKE_ENV':
        value => $airbrake_env;
      'AMQP_ADDRESS':
        value => "amqp://govuk_crawler_worker:${amqp_pass}@rabbitmq-1:5672/";
      'AMQP_EXCHANGE':
        value => 'govuk_crawler_exchange';
      'AMQP_MESSAGE_QUEUE':
        value => 'govuk_crawler_queue';
      'BLACKLIST_PATHS':
        value => join($blacklist_paths, ',');
      'HTTP_PORT':
        value => $port;
      'REDIS_ADDRESS':
        value => 'redis-1:6379';
      'REDIS_KEY_PREFIX':
        value => 'govuk_crawler_worker';
      'ROOT_URLS':
        value => 'https://www.gov.uk/,https://assets.digital.cabinet-office.gov.uk/';
      'MIRROR_ROOT':
        value => $mirror_root;
      'TTL_EXPIRE_TIME':
        value => '24h';
    }

    file { $mirror_root:
      ensure => directory,
      mode   => '0755',
      owner  => 'deploy',
      group  => 'deploy',
    }

    govuk::app { 'govuk_crawler_worker':
      app_type           => 'bare',
      log_format_is_json => true,
      port               => $port,
      command            => './govuk_crawler_worker -json',
      health_check_path  => '/healthcheck',
    }
  }
}

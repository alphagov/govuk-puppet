class govuk::apps::govuk_crawler_worker (
  $amqp_pass  = 'guest',
) {
  Govuk::App::Envvar {
    app => 'govuk_crawler_worker',
  }

  govuk::app::envvar {
    'AMQP_ADDRESS':
      value => "amqp://govuk_crawler_worker:${amqp_pass}@rabbitmq-1:5672/govuk_crawler_worker";
    'AMQP_EXCHANGE':
      value => 'govuk_crawler_exchange';
    'AMQP_MESSAGE_QUEUE':
      value => 'govuk_crawler_queue';
    'REDIS_ADDRESS':
      value => 'redis-1';
    'REDIS_KEY_PREFIX':
      value => 'govuk_crawler_worker';
    'ROOT_URL':
      value => 'https://www.gov.uk/';
  }

  govuk::app { 'govuk_crawler_worker':
    app_type => 'bare',
    command  => './govuk_crawler_worker',
  }

  govuk::logstream { 'govuk_crawler_worker-error-log':
    logfile => '/var/log/govuk_crawler_worker/default.log',
    tags    => ['error'],
    fields  => {'application' => 'govuk_crawler_worker'},
  }
}

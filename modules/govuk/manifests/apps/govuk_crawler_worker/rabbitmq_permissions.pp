class govuk::apps::govuk_crawler_worker::rabbitmq_permissions (
  $amqp_pass  = 'guest',
) {

  $amqp_user  = 'govuk_crawler_worker'

  # TODO: Remove this once deployed across all environments.
  rabbitmq_vhost { 'govuk_crawler_worker':
    ensure => absent,
  }

  rabbitmq_user { $amqp_user:
    admin    => false,
    password => $amqp_pass,
  }

  $govuk_crawler_regex = '^(govuk_crawler.*)$'
  rabbitmq_user_permissions { "${amqp_user}@$/":
    configure_permission => $govuk_crawler_regex,
    read_permission      => $govuk_crawler_regex,
    write_permission     => $govuk_crawler_regex,
  }
}

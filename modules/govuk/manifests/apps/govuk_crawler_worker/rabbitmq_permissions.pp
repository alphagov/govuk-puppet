class govuk::apps::govuk_crawler_worker::rabbitmq_permissions (
  $amqp_pass  = 'guest',
) {

  $amqp_user  = 'govuk_crawler_worker'
  $amqp_vhost = 'govuk_crawler_worker'

  rabbitmq_vhost { $amqp_vhost:
    ensure => present,
  }

  rabbitmq_user { $amqp_user:
    admin    => false,
    password => $amqp_pass,
  }

  rabbitmq_user_permissions { "${amqp_user}@${amqp_vhost}":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }
}

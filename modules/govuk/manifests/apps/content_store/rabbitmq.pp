class govuk::apps::content_store::rabbitmq (
  $amqp_pass  = 'guest',
) {

  $amqp_user  = 'content_store'
  $amqp_exchange = 'published_documents'
  $amqp_vhost = '/'

  rabbitmq_vhost { $amqp_vhost:
    ensure => present,
  }

  rabbitmq_user { $amqp_user:
    admin    => true,
    password => $amqp_pass,
  }

  rabbitmq_exchange { "${amqp_exchange}@${amqp_vhost}":
    ensure   => present,
    user     => $amqp_user,
    password => $amqp_pass,
    type     => 'topic',
  }

  rabbitmq_user_permissions { "${amqp_user}@${amqp_vhost}":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }
}

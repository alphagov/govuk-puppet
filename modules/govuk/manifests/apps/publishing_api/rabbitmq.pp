# == Class: govuk::apps::publishing_api::rabbitmq
#
# Creates an AMQP exchange and sets up permissions for the publishing_api
# to read and write messages.
#
# This sets up the user, and permits read/write/configure
# to the queue and exchange(s).
#
# === Parameters
#
# [*amqp_user*]
#   The RabbitMQ username (default: 'publishing_api')
#
# [*amqp_pass*]
#   The RabbitMQ password (default: 'publishing_api')
#
# [*amqp_exchange*]
#   The RabbitMQ exchange to read from (default: 'published_documents')
#
# [*configure_test_exchange*]
#   Whether or not to set up a test exchange for development (default: false)
#
class govuk::apps::publishing_api::rabbitmq (
  $amqp_user  = 'publishing_api',
  $amqp_pass  = 'publishing_api',
  $amqp_exchange = 'published_documents',
  $configure_test_exchange = false,
) {
  rabbitmq_user { $amqp_user:
    password => $amqp_pass,
  }

  $permissions_regex_fragment = $configure_test_exchange ? {
    true    => "${amqp_exchange}|${amqp_exchange}_test",
    default => $amqp_exchange
  }

  rabbitmq_user_permissions { "${amqp_user}@/":
    configure_permission => '^amq\.gen.*$',
    read_permission      => "^(amq\\.gen.*|${permissions_regex_fragment})$",
    write_permission     => "^(amq\\.gen.*|${permissions_regex_fragment})$",
  }

  govuk_rabbitmq::exchange { "${amqp_exchange}@/":
    type     => 'topic',
    durable  => true,
  }

  if $configure_test_exchange {
    # Used for running integration tests.
    govuk_rabbitmq::exchange { "${amqp_exchange}_test@/":
      type     => 'topic',
    }
  }
}

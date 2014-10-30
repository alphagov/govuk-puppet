# == Class: govuk::apps::content_register::rabbitmq
#
# Permissions for the content_register to read messages from
# the publishing API's AMQP exchange.
#
# This sets up the user, and permits read/write/configure
# to the queue, and read-only to the exchange.
#
# === Parameters
#
# [*password*]
#   The password for the RabbitMQ user (default: 'content_register')
#
# [*configure_test_details*]
#   Whether to configure accounts/permissions necessary for running tests
#   (default: false)
#
class govuk::apps::content_register::rabbitmq (
  $password  = 'content_register',
  $configure_test_details = false,
) {

  govuk_rabbitmq::consumer { 'content_register':
    amqp_pass     => $password,
    amqp_exchange => 'published_documents',
    amqp_queue    => 'content_register',
  }

  if $configure_test_details {
    govuk_rabbitmq::consumer { 'content_register_test':
      amqp_pass        => $password,
      amqp_exchange    => 'content_register_published_documents_test_exchange',
      amqp_queue       => 'content_register_test',
      is_test_exchange => true,
    }
  }
}

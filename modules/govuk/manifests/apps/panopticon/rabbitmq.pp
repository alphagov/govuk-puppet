# == Class: govuk::apps::panopticon::rabbitmq
#
# Permissions for panopticon to read messages from
# the publishing API's AMQP exchange.
#
# This sets up the user, and permits read/write/configure
# to the queue, and read-only to the exchange.
#
# === Parameters
#
# [*password*]
#   The password for the RabbitMQ user (default: 'panopticon')
#
# [*configure_test_details*]
#   Whether to configure accounts/permissions necessary for running tests
#   (default: false)
#
class govuk::apps::panopticon::rabbitmq (
  $password  = 'panopticon',
  $configure_test_details = false,
) {

  govuk_rabbitmq::consumer { 'panopticon':
    amqp_pass     => $password,
    amqp_exchange => 'published_documents',
    amqp_queue    => 'panopticon',
    routing_key   => '#',
  }

  if $configure_test_details {
    govuk_rabbitmq::consumer { 'panopticon_test':
      amqp_pass        => $password,
      amqp_exchange    => 'panopticon_published_documents_test_exchange',
      amqp_queue       => 'panopticon_test',
      routing_key      => '#',
      is_test_exchange => true,
    }
  }
}

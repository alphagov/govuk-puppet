# == Class: govuk::apps::rummager::rabbitmq
#
# Permissions for rummager to read messages from
# the publishing API's AMQP exchange.
#
# This sets up the user, and permits read/write/configure
# to the queue, and read-only to the exchange.
#
# === Parameters
#
# [*password*]
#   The password for the RabbitMQ user (default: 'rummager')
# [*enable_publishing_listener*]
#   Whether or not to configure the queue for the rummager indexer
#
class govuk::apps::rummager::rabbitmq (
  $password  = 'rummager',
  $enable_publishing_listener = false,
) {

  $toggled_ensure = $enable_publishing_listener ? {
    true    => present,
    default => absent,
  }

  govuk_rabbitmq::consumer { 'rummager':
    ensure        => $toggled_ensure,
    amqp_pass     => $password,
    amqp_exchange => 'published_documents',
    amqp_queue    => 'rummager_to_be_indexed',
    routing_key   => '*.links',
  }
}

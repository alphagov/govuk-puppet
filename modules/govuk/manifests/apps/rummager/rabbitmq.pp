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
# [*enable_govuk_index_listener*]
#   Whether or not to configure the queue for the rummager govuk indexer
#
class govuk::apps::rummager::rabbitmq (
  $password  = 'rummager',
  $enable_govuk_index_listener = false,
  $enable_publishing_listener = false,
) {

  $toggled_ensure = $enable_publishing_listener ? {
    true    => present,
    default => absent,
  }

  $toggled_govuk_index_listener = $enable_govuk_index_listener ? {
    true    => present,
    default => absent,
  }

  # match everything on queue 2 while we test
  govuk_rabbitmq::consumer { 'rummager-v2':
    ensure        => $toggled_ensure,
    amqp_pass     => $password,
    amqp_exchange => 'published_documents',
    amqp_queue    => 'rummager_to_be_indexed',
    routing_key   => '*.links',
    amqp_queue_2  => 'rummager_govuk_index',
    routing_key_2 => '#',
  }

  # deprecated - we will remove this user once we have migrated to the new user
  govuk_rabbitmq::consumer { 'rummager':
    ensure        => $toggled_ensure,
    amqp_pass     => $password,
    amqp_exchange => 'published_documents',
    amqp_queue    => 'rummager_to_be_indexed',
    routing_key   => '*.links',
    create_queue  => false,
  }
}

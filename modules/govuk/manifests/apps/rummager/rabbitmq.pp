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
    ensure                      => $toggled_ensure,
    amqp_pass                   => $password,
    amqp_exchange               => 'published_documents',
    amqp_queue                  => 'rummager_to_be_indexed',
    routing_key                 => '*.links',
    extra_read_permissions      => 'govuk_index_durable|govuk_index_transient',
    extra_write_permissions     => 'govuk_index_durable|govuk_index_transient',
    extra_configure_permissions => 'govuk_index_durable|govuk_index_transient',
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

  # This queue should replace `rummager_to_be_indexed`
  govuk_rabbitmq::queue_with_binding { 'govuk_index_durable':
    amqp_pass     => $password,
    amqp_exchange => 'published_documents',
    amqp_queue    => 'govuk_index_durable',
    routing_key   => '*.*',
    durable       => true
  }

  # Additional queue for reindexing.
  # We use a longer binding key so the durable queue can use wildcard matching.
  govuk_rabbitmq::queue_with_binding { 'govuk_index_transient':
    amqp_pass     => $password,
    amqp_exchange => 'published_documents',
    amqp_queue    => 'govuk_index_transient',
    routing_key   => '*.requeue.bulk',
    durable       => true
  }
}

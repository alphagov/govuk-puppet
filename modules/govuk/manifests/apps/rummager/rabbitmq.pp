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
# [*enable_bulk_reindex_listener*]
#   Whether or not to configure the queue for the rummager govuk bulk indexer
#
class govuk::apps::rummager::rabbitmq (
  $password  = 'rummager',
  $enable_govuk_index_listener = false,
  $enable_publishing_listener = false,
  $enable_bulk_reindex_listener = false,
) {

  $amqp_exchange = 'published_documents'

  $toggled_ensure = $enable_publishing_listener ? {
    true    => present,
    default => absent,
  }

  govuk_rabbitmq::queue_with_binding { 'rummager_to_be_indexed':
    ensure        => $toggled_ensure,
    amqp_exchange => $amqp_exchange,
    amqp_queue    => 'rummager_to_be_indexed',
    routing_key   => '*.links',
    durable       => true,
  }

  govuk_rabbitmq::queue_with_binding { 'rummager_govuk_index':
    ensure        => $toggled_ensure,
    amqp_exchange => $amqp_exchange,
    amqp_queue    => 'rummager_govuk_index',
    routing_key   => '*.*',
    durable       => true,
  }

  # When we want to manually refresh data in search, we can run a task in
  # publishing API to send "bulk reindex" messages. The routing key has
  # three components (*.bulk.reindex) so that it doesn't get routed to any
  # queues except for this one.
  #
  # We've kept this separate because the message publish rate is much higher
  # than we would expect from normal publishing activity, and this gives us
  # the flexibility to stop/throttle these messages if they become a problem.
  $toggled_bulk_ensure = $enable_bulk_reindex_listener ? {
    true    => present,
    default => absent,
  }

  govuk_rabbitmq::queue_with_binding { 'rummager_bulk_reindex':
    ensure        => $toggled_bulk_ensure,
    amqp_exchange => $amqp_exchange,
    amqp_queue    => 'rummager_bulk_reindex',
    routing_key   => '*.bulk.reindex',
    durable       => true,
  }

  # match everything on queue 2 while we test
  govuk_rabbitmq::consumer { 'rummager-v2':
    ensure               => $toggled_ensure,
    amqp_pass            => $password,
    read_permission      => "^(amq\\.gen.*|rummager_to_be_indexed|rummager_govuk_index|rummager_bulk_reindex|${amqp_exchange})\$",
    write_permission     => "^(amq\\.gen.*|rummager_to_be_indexed|rummager_govuk_index)\$",
    configure_permission => "^(amq\\.gen.*|rummager_to_be_indexed|rummager_govuk_index)\$",
  }

  # deprecated - we will remove this user once we have migrated to the new user
  govuk_rabbitmq::consumer { 'rummager':
    ensure               => $toggled_ensure,
    amqp_pass            => $password,
    read_permission      => "^(amq\\.gen.*|rummager_to_be_indexed|${amqp_exchange})\$",
    write_permission     => "^(amq\\.gen.*|rummager_to_be_indexed)\$",
    configure_permission => "^(amq\\.gen.*|rummager_to_be_indexed)\$",
  }
}

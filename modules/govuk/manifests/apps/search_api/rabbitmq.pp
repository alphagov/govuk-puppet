# == Class: govuk::apps::search_api::rabbitmq
#
# Permissions for search-api to read messages from
# the publishing API's AMQP exchange.
#
# This sets up the user, and permits read/write/configure
# to the queue, and read-only to the exchange.
#
# === Parameters
#
# [*password*]
#   The password for the RabbitMQ user (default: 'search-api')
# [*enable_publishing_listener*]
#   Whether or not to configure the queue for the indexer
#
# [*enable_govuk_index_listener*]
#   Whether or not to configure the queue for the govuk indexer
#
# [*enable_bulk_reindex_listener*]
#   Whether or not to configure the queue for the govuk bulk indexer
#
class govuk::apps::search_api::rabbitmq (
  $password  = 'search-api',
  $enable_govuk_index_listener = false,
  $enable_publishing_listener = false,
  $enable_bulk_reindex_listener = false,
) {

  $amqp_exchange = 'published_documents'

  govuk_rabbitmq::queue_with_binding { 'search_api_to_be_indexed':
    amqp_exchange => $amqp_exchange,
    amqp_queue    => 'search_api_to_be_indexed',
    routing_key   => '*.links',
    durable       => true,
  }

  govuk_rabbitmq::queue_with_binding { 'search_api_govuk_index':
    amqp_exchange => $amqp_exchange,
    amqp_queue    => 'search_api_govuk_index',
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
  if $enable_bulk_reindex_listener {
    govuk_rabbitmq::queue_with_binding { 'search_api_bulk_reindex':
      amqp_exchange => $amqp_exchange,
      amqp_queue    => 'search_api_bulk_reindex',
      routing_key   => '*.bulk.reindex',
      durable       => true,
    }
  }

  # todo: remove these expiration times when we have search-api set up
  # and processing the queues properly.
  rabbitmq_policy { 'search_api-ttl@/':
    pattern    => 'search_api*',
    priority   => 0,
    applyto    => 'queues',
    definition => {
      'ha-mode'      => 'all',
      'ha-sync-mode' => 'automatic',
      'message-ttl'  => 300000, # 5 minutes
    },
  }
}

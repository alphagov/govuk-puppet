# == Class: govuk::apps::content_store::rabbitmq
#
# Sets up permissions for the content_store
# to read and write messages.
#
# This sets up the user, and permits read/write/configure
# to the queue and exchange(s).
#
# This configuration is here to allow both the content store
# and the publishing API to write to these queues during the transitional
# period.  This permission can be removed once the deploy is complete.
#
# FIXME: This class should be removed completely once the perms have been
# purged.
#
# === Parameters
#
# [*amqp_user*]
#   The RabbitMQ username (default: 'content_store')
#
# [*amqp_pass*]
#   The RabbitMQ password (default: 'content_store')
#
# [*amqp_exchange*]
#   The RabbitMQ exchange to read from (default: 'published_documents')
#
class govuk::apps::content_store::rabbitmq (
  $amqp_user  = 'content_store',
  $amqp_pass  = 'content_store',
  $amqp_exchange = 'published_documents',
) {
  rabbitmq_user { $amqp_user:
    ensure => absent
  }

  rabbitmq_user_permissions { "${amqp_user}@/":
    ensure => absent
  }
}

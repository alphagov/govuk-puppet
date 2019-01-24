# == Class: govuk::apps::cache_clearing_service::rabbitmq
#
# Permissions for the cache_clearing_service to read messages from
# the publishing API's AMQP exchange.
#
# This sets up the user, and permits read/write/configure
# to the queue, and read-only to the exchange.
#
# === Parameters
#
# [*amqp_user*]
#   The RabbitMQ username (default: 'cache_clearing_service')
#
# [*amqp_pass*]
#   The RabbitMQ password. This is a required parameter.
#
# [*amqp_exchange*]
#   The RabbitMQ exchange to read from (default: 'published_documents')
#
# [*amqp_queue*]
#   The RabbitMQ queue to set up for workers of this type to read from
#   (default: 'cache_clearing_service')
#
class govuk::apps::cache_clearing_service::rabbitmq (
  $amqp_user  = 'cache_clearing_service',
  $amqp_pass = 'cache_clearing_service',
  $amqp_exchange = 'published_documents',
  $amqp_queue = 'cache_clearing_service',
  $queue_size_critical_threshold,
  $queue_size_warning_threshold,
) {
  $high_queue = "${amqp_queue}-high" # major, unpublish
  $medium_queue = "${amqp_queue}-medium" # minor, republish
  $low_queue = "${amqp_queue}-low" # links

  govuk_rabbitmq::queue_with_binding { $high_queue:
    ensure        => 'present',
    amqp_exchange => $amqp_exchange,
    amqp_queue    => $high_queue,
    routing_key   => '*.major',
    durable       => true,
  }

  rabbitmq_binding { "binding_unpublish_${amqp_exchange}@${high_queue}@/":
    ensure           => 'present',
    name             => "${amqp_exchange}@${high_queue}@unpublish@/",
    user             => 'root',
    password         => $::govuk_rabbitmq::root_password,
    destination_type => 'queue',
    routing_key      => '*.unpublish',
    arguments        => {},
    require          => Govuk_rabbitmq::Queue_with_binding[$high_queue],
  }

  govuk_rabbitmq::queue_with_binding { $medium_queue:
    ensure        => 'present',
    amqp_exchange => $amqp_exchange,
    amqp_queue    => $medium_queue,
    routing_key   => '*.minor',
    durable       => true,
  }

  rabbitmq_binding { "binding_republish_${amqp_exchange}@${medium_queue}@/":
    ensure           => 'present',
    name             => "${amqp_exchange}@${medium_queue}@republish@/",
    user             => 'root',
    password         => $::govuk_rabbitmq::root_password,
    destination_type => 'queue',
    routing_key      => '*.republish',
    arguments        => {},
    require          => Govuk_rabbitmq::Queue_with_binding[$medium_queue],
  }

  govuk_rabbitmq::queue_with_binding { $low_queue:
    ensure        => 'present',
    amqp_exchange => $amqp_exchange,
    amqp_queue    => $low_queue,
    routing_key   => '*.links',
    durable       => true,
  }

  rabbitmq_policy { "${low_queue}-ttl@/":
    pattern    => "${low_queue}.*",
    priority   => 0,
    applyto    => 'queues',
    definition => {
      'ha-mode'      => 'all',
      'ha-sync-mode' => 'automatic',
      'message-ttl'  => 3600000, # one hour
    },
  }

  govuk_rabbitmq::consumer { $amqp_user:
    ensure               => 'present',
    amqp_pass            => $amqp_pass,
    read_permission      => "^${amqp_queue}-\\w+\$",
    write_permission     => "^\$",
    configure_permission => "^\$",
  }

  govuk_rabbitmq::monitor_messages {"${high_queue}_message_monitoring":
    ensure             => present,
    rabbitmq_hostname  => 'localhost',
    rabbitmq_queue     => $high_queue,
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
    require            => Govuk_rabbitmq::Queue_with_binding[$high_queue],
  }

  govuk_rabbitmq::monitor_messages {"${medium_queue}_message_monitoring":
    ensure             => present,
    rabbitmq_hostname  => 'localhost',
    rabbitmq_queue     => $medium_queue,
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
    require            => Govuk_rabbitmq::Queue_with_binding[$medium_queue],
  }

  govuk_rabbitmq::monitor_messages {"${low_queue}_message_monitoring":
    ensure             => present,
    rabbitmq_hostname  => 'localhost',
    rabbitmq_queue     => $low_queue,
    critical_threshold => $queue_size_critical_threshold,
    warning_threshold  => $queue_size_warning_threshold,
    require            => Govuk_rabbitmq::Queue_with_binding[$low_queue],
  }
}

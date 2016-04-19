# == Define: govuk_rabbitmq::remove_queues
#
# Removes the named rabbitmq queues on a particular vhost.
# Multiple queues can be removed at once by passing an array.
#
# If any queues to be removed clash with other queue declarations
# in the catalogue, puppet will error, so it is not possible to add
# and remove the same queue at once by mistake.
#
# === Parameters
#
# [*amqp_vhost*]
#   The RabbitMQ vhost from which to delete queues.
#
define govuk_rabbitmq::remove_queues (
  $amqp_vhost,
) {

  $amqp_queue = $title

  rabbitmq_queue { "${amqp_queue}@${amqp_vhost}":
    ensure   => absent,
    user     => 'root',
    password => $::govuk_rabbitmq::root_password,
  }
}

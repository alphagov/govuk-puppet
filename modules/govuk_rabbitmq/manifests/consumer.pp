# == Define: govuk_rabbitmq::consumer
#
# Creates a rabbitmq user with specified permissions.
#
# === Parameters
#
# [*amqp_pass*]
#   The RabbitMQ password for the $title user.
#
# [*read_permission*]
#   The read permission for the $title user.
#
# [*write_permission*]
#   The write permission for the $title user.
#
# [*configure_permission*]
#   The configure permission for the $title user.
#
# [*ensure*]
#   Determines whether to create or delete the consumer.
#   (default: present)
#
define govuk_rabbitmq::consumer (
  $amqp_pass,
  $write_permission,
  $read_permission,
  $configure_permission,
  $ensure = present,
) {
  validate_re($ensure, '^(present|absent)$', '$ensure must be "present" or "absent"')

  $amqp_user = $title

  include ::govuk_rabbitmq

  if $ensure == present {
    rabbitmq_user { $amqp_user:
      ensure   => present,
      password => $amqp_pass,
    } ->
    rabbitmq_user_permissions { "${amqp_user}@/":
      ensure               => present,
      read_permission      => $read_permission,
      write_permission     => $write_permission,
      configure_permission => $configure_permission,
    }
  } else {
    rabbitmq_user { $amqp_user:
      ensure   => absent,
    }
  }
}

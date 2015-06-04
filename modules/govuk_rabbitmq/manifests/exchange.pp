# == Define: govuk_rabbitmq::exchange
#
# Manage a rabbitmq exchange.  This is just a wrapper around
# the rabbitmq module's defined type that adds the 'root' user
# creds.
#
# === Parameters
#
# [*ensure*]
#   Ensure the presence state of this RabbitMQ exchange
#   Default: present
#
# [*type*]
#   Type of RabbitMQ exchange to create
#   Default: undef
#
define govuk_rabbitmq::exchange (
  $ensure = present,
  $type = undef,
) {

  if $ensure == 'present' {
    if $type == undef {
      fail('Must provide type when ensuring exchange is present.')
    }
  }

  rabbitmq_exchange { $name:
    ensure   => $ensure,
    user     => 'root',
    password => $::govuk_rabbitmq::root_password,
    type     => $type,
  }
}

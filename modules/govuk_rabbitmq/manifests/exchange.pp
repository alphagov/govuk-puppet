# == Define: govuk_rabbitmq::exchange
#
# Manage a rabbitmq exchange.  This is just a wrapper around
# the rabbitmq module's defined type that adds the 'root' user
# creds.
#
define govuk_rabbitmq::exchange (
  $type,
  $ensure = present,
) {

  rabbitmq_exchange { $name:
    ensure   => $ensure,
    user     => 'root',
    password => $::govuk_rabbitmq::root_password,
    type     => $type,
  }
}

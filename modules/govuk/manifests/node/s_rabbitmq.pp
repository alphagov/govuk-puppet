# == Class: govuk::node::s_rabbitmq
#
# Machines running RabbitMQ.
#
# === Parameters
#
# [*apps_using_rabbitmq*]
#   A list of GOV.UK applications which use RabbitMQ
#
class govuk::node::s_rabbitmq (
  $apps_using_rabbitmq = [],
) inherits govuk::node::s_base {
  validate_array($apps_using_rabbitmq)

  include govuk_rabbitmq

  $app_rabbitmq_classes = regsubst(regsubst($apps_using_rabbitmq, '^', 'govuk::apps::'), '$', '::rabbitmq')
  include $app_rabbitmq_classes
}

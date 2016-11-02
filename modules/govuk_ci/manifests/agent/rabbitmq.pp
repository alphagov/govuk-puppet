# == Class: govuk_ci::agent::rabbitmq
#
# Installs and configures rabbitmq-server
#
class govuk_ci::agent::rabbitmq {
  include ::govuk_rabbitmq
}

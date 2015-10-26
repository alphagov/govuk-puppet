# == Class: govuk::node::s_rabbitmq
#
# Machines running RabbitMQ.
#
class govuk::node::s_rabbitmq inherits govuk::node::s_base {
  include govuk_rabbitmq
  include govuk::apps::govuk_crawler_worker::rabbitmq_permissions
  include govuk::apps::backdrop_write::rabbitmq
  include govuk::apps::content_register::rabbitmq
  include govuk::apps::panopticon::rabbitmq
  include govuk::apps::email_alert_service::rabbitmq_permissions
  include govuk::apps::publishing_api::rabbitmq
  include govuk::apps::stagecraft::rabbitmq
}

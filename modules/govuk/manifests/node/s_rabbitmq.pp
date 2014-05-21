class govuk::node::s_rabbitmq inherits govuk::node::s_base {
  include govuk_rabbitmq
  include govuk::apps::govuk_crawler_worker::rabbitmq_permissions
}

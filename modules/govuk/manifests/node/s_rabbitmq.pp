# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_rabbitmq inherits govuk::node::s_base {
  include govuk_rabbitmq
  include govuk::apps::govuk_crawler_worker::rabbitmq_permissions
  include govuk::apps::content_store::rabbitmq
  include govuk::apps::email_alert_service::rabbitmq_permissions
}

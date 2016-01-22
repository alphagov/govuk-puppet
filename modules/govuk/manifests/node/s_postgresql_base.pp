# == Class: govuk::node::s_postgresql_base
#
# Base node for s_postgresql_{master,slave}
#
class govuk::node::s_postgresql_base inherits govuk::node::s_base {
  include govuk::apps::content_register::db
  include govuk::apps::content_tagger::db
  include govuk::apps::email_alert_api::db
  include govuk::apps::policy_publisher::db
  include govuk::apps::publishing_api::db
  include govuk::apps::service_manual_publisher::db
  include govuk::apps::support_api::db

  Govuk_mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']
}

# == Class: govuk::node::s_postgresql_base
#
# Base node for s_postgresql_{master,slave}
#
class govuk::node::s_postgresql_base inherits govuk::node::s_base {
  include govuk::apps::email_alert_api::db
  include govuk::apps::url_arbiter::db

  Govuk::Mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']
}

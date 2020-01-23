# == Class: govuk::node::s_postgresql_base
#
# Base node for s_postgresql_{master,slave}
#
class govuk::node::s_postgresql_base inherits govuk::node::s_base {
  include govuk_pgbouncer

  include govuk::apps::content_publisher::db
  include govuk::apps::content_tagger::db
  include govuk::apps::service_manual_publisher::db

  include govuk_postgresql::tuning

  Govuk_mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']
}

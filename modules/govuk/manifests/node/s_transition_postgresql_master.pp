# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_transition_postgresql_master inherits govuk::node::s_base {
  include govuk_postgresql::server

  include govuk::apps::transition_postgres::db

  Govuk::Mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']
}

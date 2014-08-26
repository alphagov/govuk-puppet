# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_postgresql_master inherits govuk::node::s_base {
  include govuk_postgresql::server::master

  include govuk::apps::url_arbiter::db

  Govuk::Mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']
}

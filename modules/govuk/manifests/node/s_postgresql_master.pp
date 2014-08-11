class govuk::node::s_postgresql_master inherits govuk::node::s_base {
  include govuk_postgresql::server

  include govuk::apps::url_arbiter::db

  Govuk::Mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']
}

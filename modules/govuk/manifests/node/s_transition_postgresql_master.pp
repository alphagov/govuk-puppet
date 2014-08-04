class govuk::node::s_transition_postgresql_master inherits govuk::node::s_base {
  include govuk_postgresql::server

  Govuk::Mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']
}

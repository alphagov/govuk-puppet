class govuk::node::s_transition_postgresql_master inherits govuk::node::s_base {
  include postgresql::server

  Govuk::Mount['/var/lib/postgresql'] -> Class['postgresql::server']
}

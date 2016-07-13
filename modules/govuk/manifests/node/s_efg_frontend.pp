# == Class: govuk::node::s_efg_frontend
#
# Class to define machines that run the EFG frontend
#
class govuk::node::s_efg_frontend inherits govuk::node::s_base {
  include govuk::node::s_app_server

  include nginx
}

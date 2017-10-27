# == Class: govuk::node::s_api
#
class govuk::node::s_api inherits govuk::node::s_base {
  include nginx

  include govuk::node::s_app_server
}

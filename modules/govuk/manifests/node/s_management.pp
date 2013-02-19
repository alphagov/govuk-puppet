class govuk::node::s_management inherits govuk::node::s_base {
  include govuk::node::s_management_base
  include jenkins::master
  include govuk::openconnect
}

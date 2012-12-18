class govuk::node::management_server_master inherits govuk::node::base {
  include govuk::node::management_server
  include jenkins::master
}

class govuk_node::management_server_master inherits govuk_node::base {
  include govuk_node::management_server
  include jenkins::master
}

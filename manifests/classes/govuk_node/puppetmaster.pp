class govuk_node::puppetmaster inherits govuk_node::base {
  include puppet::master
  include puppetdb
}

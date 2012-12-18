class govuk_node::puppetmaster inherits govuk_node::base {
  class {'puppet::master':
    subscribe => Class['ruby::rubygems'],
  }
  include puppetdb
}

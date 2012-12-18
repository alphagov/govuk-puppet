class govuk::node::puppetmaster inherits govuk::node::base {
  class {'puppet::master':
    subscribe => Class['ruby::rubygems'],
  }
  include puppetdb
}

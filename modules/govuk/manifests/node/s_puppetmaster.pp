# == Class: govuk::node::s_puppetmaster
#
# Configures node with govuk_class=puppetmaster
#
class govuk::node::s_puppetmaster inherits govuk::node::s_base {
  class { 'puppet::master':
    subscribe => Class['ruby::rubygems'],
  }
}

# == Class: govuk::node::s_puppetmaster
#
# Configures node with govuk_class=puppetmaster
#
class govuk::node::s_puppetmaster inherits govuk::node::s_base {
  class { 'puppet::master':
    puppet_version => '3.2.2-1puppetlabs1',
    subscribe      => Class['ruby::rubygems'],
  }
}

class govuk::node::s_puppet inherits govuk::node::s_base {
  class { 'puppet::master':
    subscribe => Class['ruby::rubygems'],
  }
}

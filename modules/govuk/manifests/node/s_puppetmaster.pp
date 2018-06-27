# == Class: govuk::node::s_puppetmaster
#
class govuk::node::s_puppetmaster inherits govuk::node::s_base {
  if $::lsbdistcodename == 'trusty' {
    include '::puppet::puppetserver'
    include '::govuk_postgresql::backup'
  }
  else {
    fail("Distro ${::lsbdistcodename} not supported")
  }
}

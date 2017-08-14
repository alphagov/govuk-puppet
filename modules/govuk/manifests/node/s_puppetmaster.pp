# == Class: govuk::node::s_puppetmaster
#
class govuk::node::s_puppetmaster inherits govuk::node::s_base {
  include govuk_postgresql::backup

  if $::aws_migration {
    include puppet::puppetserver
  } else {
    include puppet::master
  }
}

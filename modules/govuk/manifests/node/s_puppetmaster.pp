# == Class: govuk::node::s_puppetmaster
#
class govuk::node::s_puppetmaster inherits govuk::node::s_base {
  if $::aws_migration {
    include puppet::puppetserver
  } elsif ($::lsbdistcodename == 'trusty') {
      include puppet::puppetserver
  } else {
      include puppet::master
  }
}

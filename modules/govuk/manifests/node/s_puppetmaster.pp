# == Class: govuk::node::s_puppetmaster
#
class govuk::node::s_puppetmaster inherits govuk::node::s_base {
  include govuk_postgresql::backup

  if $::aws_migration {
    include puppet::puppetserver

    # We do not allow other hosts to connect to puppetdb, so the reboot check
    # lives on the Puppetmaster, and we alias puppetdb to localhost so we
    # do not go back out and in through the load balancer.
    include monitoring::checks::reboots
    host { 'puppetdb':
      ensure => 'present',
      ip     => '127.0.0.1',
    }
  } else {
    include puppet::master
  }
}

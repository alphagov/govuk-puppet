# == Class: puppet::master
#
# Install and configure a puppet master served by nginx and unicorn.
#
# === Parameters
#
# [*unicorn_port*]
#   Specify the port on which unicorn (and hence the puppetmaster) should
#   listen.
#
class puppet::master($unicorn_port='9090') {
  include puppet::repository
  include nginx
  include unicornherder

  anchor {'puppet::master::begin':
    notify => Class['puppet::master::service'],
  }
  class{'puppet::master::package':
    require => [
        Class['unicornherder'],
        Anchor['puppet::master::begin']
    ],
  }
  class{'puppet::master::config':
    unicorn_port => $unicorn_port,
    require      => Class['puppet::master::package'],
    notify       => Class['puppet::master::service'],
  }
  class { 'puppet::master::generate_cert':
    require   => Class['puppet::master::config'],
  }
  class{'puppet::master::service':
    # This subscribe is here because /etc/puppet/puppet.conf is currently
    # provided by a manifest separate from puppet::master::*. TODO: move
    # master puppet.conf into the configuration of the puppetmaster.
    subscribe => File['/etc/puppet/puppet.conf'],
    notify    => Anchor['puppet::master::end'],
    require   => Class['puppet::master::generate_cert'],
  }
  anchor {'puppet::master::end': }
}

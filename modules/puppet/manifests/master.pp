# == Class: puppet::master
#
# Install and configure a puppet master served by nginx and unicorn.
# Includes PuppetDB of a fixed version on the same host.
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

  $puppetdb_version = '1.0.2-1puppetlabs1'

  class { '::puppetdb':
    package_ensure => $puppetdb_version,
  }

  anchor {'puppet::master::begin':
    notify => Class['puppet::master::service'],
  }
  class{'puppet::master::package':
    puppetdb_version  => $puppetdb_version,
    require           => [
      Class['unicornherder'],
      Anchor['puppet::master::begin'],
    ],
  }
  class{'puppet::master::config':
    unicorn_port => $unicorn_port,
    require      => Class['puppet::master::package'],
    notify       => Class['puppet::master::service'],
  }
  class{'puppet::master::service':
    # This subscribe is here because /etc/puppet/puppet.conf is currently
    # provided by a manifest separate from puppet::master::*. TODO: move
    # master puppet.conf into the configuration of the puppetmaster.
    subscribe => File['/etc/puppet/puppet.conf'],
    notify    => Anchor['puppet::master::end'],
  }
  anchor {'puppet::master::end': }
}

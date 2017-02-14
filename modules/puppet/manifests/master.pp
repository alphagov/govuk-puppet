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
# [*puppetdb_version*]
#   Specify the version of puppetdb to be installed

class puppet::master(
  $unicorn_port = '9090',
  $puppetdb_version = '1.3.2-1puppetlabs1',
) {
  include puppet::repository
  include unicornherder

  class { '::govuk_puppetdb':
    package_ensure => $puppetdb_version,
  }

  anchor {'puppet::master::begin':
    notify => Class['puppet::master::service'],
  }
  class{'puppet::master::package':
    puppetdb_version => $puppetdb_version,
    notify           => Class['puppet::master::service'],
    require          => [
      Class['puppet::package'],
      Class['unicornherder'],
      Anchor['puppet::master::begin'],
    ],
    unicorn_port     => $unicorn_port,
  }
  class{'puppet::master::config':
    unicorn_port => $unicorn_port,
    require      => Class['puppet::master::package'],
    notify       => Class['puppet::master::service'],
  }
  class { 'puppet::master::generate_cert':
    require   => Class['puppet::master::config'],
  }

  class { 'puppet::master::firewall':
    require => Class['puppet::master::config'],
  }

  class{'puppet::master::service':
    # This subscribe is here because /etc/puppet/puppet.conf is currently
    # provided by a manifest separate from puppet::master::*. TODO: move
    # master puppet.conf into the configuration of the puppetmaster.
    subscribe => [
      File['/etc/puppet/puppet.conf'],
      Class['puppet::package'],
    ],
    require   => Class['puppet::master::generate_cert'],
  }

  class { 'puppet::master::nginx':
    unicorn_port => $unicorn_port,
    require      => Class['puppet::master::generate_cert'],
  }

  file { '/etc/puppet/gpg':
    ensure  => directory,
    mode    => '0700',
    recurse => true,
    owner   => 'puppet',
    group   => 'puppet',
  }

  anchor {'puppet::master::end':
    subscribe =>  Class['puppet::master::service'],
    require   =>  [
                    Class['puppet::master::firewall'],
                    Class['puppet::master::nginx'],
                    File['/etc/puppet/gpg'],
                  ],
  }

  cron::crondotdee { 'puppet_report_purge':
    command => '/usr/bin/find /var/lib/puppet/reports/ -type f -mtime +1 -delete',
    hour    => 6,
    minute  => 45,
  }
}

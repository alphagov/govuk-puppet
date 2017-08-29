# == Class: puppet::puppetserver
#
# Install and configure a puppetserver.
# Includes PuppetDB of a fixed version on the same host.
#
# === Parameters
#
# [*puppetdb_version*]
#   Specify the version of puppetdb to be installed

class puppet::puppetserver(
  $puppetdb_version = '1.3.2-1puppetlabs1',
) {
  include puppet::repository

  class { '::govuk_puppetdb':
    package_ensure => $puppetdb_version,
  }

  anchor {'puppet::puppetserver::begin':
    notify => Class['puppet::puppetserver::service'],
  }
  class{'puppet::puppetserver::package':
    puppetdb_version => $puppetdb_version,
    notify           => Class['puppet::puppetserver::service'],
    require          => [
      Class['puppet::package'],
      Anchor['puppet::puppetserver::begin'],
    ],
  }
  class{'puppet::puppetserver::config':
    require => Class['puppet::puppetserver::package'],
    notify  => Class['puppet::puppetserver::service'],
  }
  class { 'puppet::puppetserver::generate_cert':
    require   => Class['puppet::puppetserver::config'],
  }

  class { 'puppet::puppetserver::firewall':
    require => Class['puppet::puppetserver::config'],
  }

  class{'puppet::puppetserver::service':
    subscribe => [
      Class['puppet::package'],
    ],
    require   => Class['puppet::puppetserver::generate_cert'],
  }

  class { 'puppet::puppetserver::nginx':
    require      => Class['puppet::puppetserver::generate_cert'],
  }

  file { '/etc/puppet/gpg':
    ensure  => directory,
    mode    => '0700',
    recurse => true,
    owner   => 'puppet',
    group   => 'puppet',
  }

  anchor {'puppet::puppetserver::end':
    subscribe =>  Class['puppet::puppetserver::service'],
    require   =>  [
                    Class['puppet::puppetserver::firewall'],
                    Class['puppet::puppetserver::nginx'],
                    File['/etc/puppet/gpg'],
                  ],
  }

  cron::crondotdee { 'puppet_report_purge':
    command => '/usr/bin/find /var/lib/puppet/reports/ -type f -mtime +1 -delete',
    hour    => 6,
    minute  => 45,
  }

  file { '/usr/local/bin/puppet_node_clean.sh':
    ensure => present,
    mode   => '0750',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/puppet/puppet_node_clean.sh',
  }

  cron::crondotdee { 'puppet_node_clean':
    command => '/usr/local/bin/puppet_node_clean.sh >> /var/log/govuk/puppet_node_clean.log 2>&1',
    hour    => '*',
    minute  => '*/5',
    require => File['/usr/local/bin/puppet_node_clean.sh'],
  }

}

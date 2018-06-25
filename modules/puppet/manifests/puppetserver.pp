# == Class: puppet::puppetserver
#
# Install and configure a puppetserver.
# Includes PuppetDB on the same host.
#
# === Parameters
#
class puppet::puppetserver {
  include '::puppet::repository'
  include '::puppet'
  include '::puppet::puppetdb'

  include '::puppet::puppetserver::package'
  contain '::puppet::puppetserver::package'

  class { '::puppet::puppetserver::config':
    require => Class['::puppet::puppetserver::package'],
    notify  => Class['::puppet::puppetserver::service'],
  }
  contain '::puppet::puppetserver::config'

  class { '::puppet::puppetserver::generate_cert':
    require => Class['::puppet::puppetserver::package'],
    notify  => Class['::puppet::puppetserver::service'],
  }
  contain '::puppet::puppetserver::config'

  class { '::puppet::puppetserver::firewall':
    require => Class['::puppet::puppetserver::config'],
    before  => Class['::puppet::puppetserver::service'],
  }
  contain '::puppet::puppetserver::firewall'

  include '::puppet::puppetserver::service'
  contain '::puppet::puppetserver::service'

  class { '::puppet::puppetserver::nginx':
    require => Class['::puppet::puppetserver::generate_cert'],
  }
  contain '::puppet::puppetserver::nginx'

  file { '/etc/puppet/gpg':
    ensure  => directory,
    mode    => '0700',
    recurse => true,
    owner   => 'puppet',
    group   => 'puppet',
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

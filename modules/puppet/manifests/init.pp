class puppet {
  $facter_version = '1.7.2-1puppetlabs1'
  $puppet_version = '3.2.3-1puppetlabs1'

  include puppet::repository

  package { 'facter':
    ensure => $facter_version,
  }
  package { 'puppet-common':
    ensure  => $puppet_version,
    require => Package['facter'],
  }
  package { 'puppet':
    ensure  => $puppet_version,
    require => Package['puppet-common'],
  }

  file { '/usr/bin/puppet':
    ensure  => present,
    source  => 'puppet:///modules/puppet/usr/bin/puppet',
    mode    => '0755',
    require => Package['puppet-common'],
  }
  file { '/usr/local/bin/puppet':
    ensure  => absent,
    require => File['/usr/bin/puppet'],
  }
  file { '/usr/local/bin/facter':
    ensure  => absent,
    require => Package['facter'],
  }

  user { 'puppet':
    ensure  => present,
    name    => 'puppet',
    home    => '/var/lib/puppet',
    shell   => '/bin/false',
    gid     => 'puppet',
    system  => true,
  }

  group { 'puppet':
    ensure  => present,
    name    => 'puppet',
    require => Package['puppet-common'],
  }

  # This is required to allow Puppet to set the password hash for the ubuntu user
  # TODO: Provide this under different rbenv versions?
  package { 'libshadow':
    ensure   => present,
    provider => gem,
    require  => Package['build-essential'],
  }

  file { '/etc/puppet/puppet.conf':
    ensure  => present,
    mode    => '0644',
    content => template('puppet/etc/puppet/puppet.conf.erb'),
  }

  file { '/usr/local/bin/govuk_puppet':
    ensure => present,
    mode   => '0755',
    source => [
      "puppet:///modules/puppet/govuk_puppet_${::govuk_platform}",
      'puppet:///modules/puppet/govuk_puppet'
    ],
  }

  file { '/usr/local/bin/puppet_passive_check_update':
    ensure  => present,
    mode    => '0755',
    content => template('puppet/puppet_passive_check_update'),
  }

  service { 'puppet': # we're using cron, so we don't want the daemonized puppet agent
    ensure   => stopped,
    provider => base,
    pattern  => '/usr/bin/puppet agent$';
  }

  @nagios::plugin { 'check_puppet_agent':
    source  => 'puppet:///modules/puppet/usr/lib/nagios/plugins/check_puppet_agent',
  }

  @@nagios::passive_check { "check_puppet_${::hostname}":
    service_description => 'puppet last run errors',
    host_name           => $::fqdn,
    freshness_threshold => 7200,
  }
}

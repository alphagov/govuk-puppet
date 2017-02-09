# == Class: puppet
#
# Sets up configuration management.
#
# === Parameters
#
# [*use_puppetmaster*]
#   Whether this environment should be controlled by a master
#   or should run from a local catalog.
#
# [*future_parser*]
#   Boolean, whether or not to use Puppet's future parser to
#   help upgrade to Puppet 4.
#
class puppet (
    $future_parser = false,
    $use_puppetmaster = true,
  ) {

  validate_bool($future_parser)
  validate_bool($use_puppetmaster)

  include puppet::cronjob
  include puppet::repository
  include puppet::package
  include puppet::monitoring

  user { 'puppet':
    ensure  => present,
    name    => 'puppet',
    home    => '/var/lib/puppet',
    shell   => '/bin/false',
    gid     => 'puppet',
    system  => true,
    require => Class['puppet::package'],
  }

  group { 'puppet':
    ensure  => present,
    name    => 'puppet',
    require => Class['puppet::package'],
  }

  file { '/etc/puppet/puppet.conf':
    ensure  => present,
    mode    => '0644',
    content => template('puppet/etc/puppet/puppet.conf.erb'),
    require => Class['puppet::package'],
  }

  if $use_puppetmaster {
    $govuk_puppet_template = 'puppet/govuk_puppet'
  } else {
    $govuk_puppet_template = 'puppet/govuk_puppet_development'
  }

  $lock_dir = '/var/lib/govuk_puppet'

  file { $lock_dir:
    ensure => directory,
  }

  file { '/usr/local/bin/govuk_puppet':
    ensure  => present,
    mode    => '0755',
    content => template($govuk_puppet_template),
    require => File[$lock_dir],
  }

  if $::lsbdistcodename == 'xenial' {
    service { 'puppet':
      ensure  => stopped,
      enable  => false,
      require => Class['puppet::package'],
    }
  } else {
    service { 'puppet': # we're using cron, so we don't want the daemonized puppet agent
      ensure   => stopped,
      provider => base,
      pattern  => '/usr/bin/puppet agent$',
      require  => Class['puppet::package'],
    }
  }
}

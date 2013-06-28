# == Class: puppet::master::package
#
# Install packages for a Puppet Master. Currently includes some generic
# dependencies like `puppet` and `puppet-common` which should eventually be
# broken into a "base" sub-class.
#
# === Parameters
#
# [*puppet_version*]
#   Specify version of puppet-common and puppet
#
# [*puppetdb_version*]
#   Specify the version of puppetdb-terminus to install which should match
#   the puppetdb installation. Passed in by parent class.
#
class puppet::master::package(
  $puppet_version = 'present',
  $puppetdb_version = 'present',
) {
  package { 'unicorn':
    provider => gem,
  }
  exec {'install rack 1.0.1':
    command => 'gem install rack --no-rdoc --no-ri --version 1.0.1',
    unless  => 'gem list | grep "rack.*1.0.1"'
  }
  package { 'puppet-common':
    ensure => $puppet_version,
  }
  package { 'puppetdb-terminus':
    ensure  => $puppetdb_version,
    require => Package['puppet-common'],
  }
  package { 'puppet':
    ensure  => $puppet_version,
    require => Package['puppet-common'],
  }
  file {['/var/log/puppetmaster','/var/run/puppetmaster']:
    ensure  => directory,
    owner   => 'puppet',
    group   => 'puppet',
    require => Package['puppet-common'],
  }
  file { '/var/lib/puppet/log':
    ensure  => directory,
    mode    => '0750',
    owner   => 'puppet',
    group   => 'puppet',
    require => Package['puppet-common'],
  }
  file { '/etc/init/puppetmaster.conf':
    content => template('puppet/etc/init/puppetmaster.conf.erb'),
  }
}

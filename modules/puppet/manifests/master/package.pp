# == Class: puppet::master::package
#
# Install packages for a Puppet Master.
#
# === Parameters
#
# [*puppetdb_version*]
#   Specify the version of puppetdb-terminus to install which should match
#   the puppetdb installation. Passed in by parent class.
#
class puppet::master::package(
  $puppetdb_version = 'present',
) {
  include ::puppet

  package { 'unicorn':
    provider => system_gem,
  }

  exec {'install rack 1.0.1':
    command => 'gem install rack --no-rdoc --no-ri --version 1.0.1',
    unless  => 'gem list | grep "rack.*1.0.1"'
  }

  package { 'puppetdb-terminus':
    ensure  => $puppetdb_version,
  }

  file {['/var/log/puppetmaster','/var/run/puppetmaster']:
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
  }

  file { '/var/lib/puppet/log':
    ensure => directory,
    mode   => '0750',
    owner  => 'puppet',
    group  => 'puppet',
  }

  file { '/etc/init/puppetmaster.conf':
    content => template('puppet/etc/init/puppetmaster.conf.erb'),
  }
}

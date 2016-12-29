# == Class: puppet::master::package
#
# Install packages for a Puppet Master.
#
# === Parameters
#
# [*hiera_eyaml_gpg_version*]
#  Specify the version of hiera_eyaml_gpg to install.
#
# [*puppetdb_version*]
#   Specify the version of puppetdb-terminus to install which should match
#   the puppetdb installation. Passed in by parent class.
#
# [*unicorn_port*]
#   Specify the port on which unicorn (and hence the puppetmaster) should
#   listen.
#
# [*puppet_sentry_dsn*]
#   This is the DSN to send puppet reports to.
#
class puppet::master::package(
  $hiera_eyaml_gpg_version = 'latest',
  $puppetdb_version = 'present',
  $unicorn_port = '9090',
  $puppet_sentry_dsn = undef,
) {
  include ::puppet

  package { 'ruby-hiera-eyaml-gpg':
    ensure => $hiera_eyaml_gpg_version,
  }

  package { 'unicorn':
    provider => system_gem,
  }

  package { 'rack':
    ensure   => '1.0.1',
    provider => system_gem,
  }

  package { 'puppetdb-terminus':
    ensure  => $puppetdb_version,
  }

  package { 'sentry-raven':
    ensure   => '2.2.0',
    provider => 'system_gem',
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

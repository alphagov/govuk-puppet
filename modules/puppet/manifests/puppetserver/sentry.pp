# == Class: puppet::puppetserver::sentry
#
# Installs the sentry-raven Ruby Gem into the PuppetServer and sets the
# PUPPET_SENTRY_DSN environment variable.
#
class puppet::puppetserver::sentry {
  exec { '/usr/bin/puppetserver gem install sentry-raven':
    unless  => '/usr/bin/puppetserver gem list | /bin/grep sentry-raven',
  }

  file_line { 'puppetserver_sentry_dsn':
    ensure => present,
    path   => '/etc/default/puppetserver',
    line   => sprintf('export PUPPET_SENTRY_DSN="%s"', $::puppet::puppetserver::sentry_dsn),
    match  => '^export PUPPET_SENTRY_DSN=',
  }
}

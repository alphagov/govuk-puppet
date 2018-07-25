# == Class: puppet::puppetserver::sentry
#
# Installs the sentry-raven Ruby Gem into the PuppetServer and sets the
# Sentry DSN in /etc/puppet/sentry.conf.
#
class puppet::puppetserver::sentry {
  exec { '/usr/bin/puppetserver gem install sentry-raven':
    unless  => '/usr/bin/puppetserver gem list | /bin/grep sentry-raven',
  }

  file { "${settings::confdir}/sentry.conf":
    ensure  => present,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0400',
    content => sprintf('dsn=%s', $::puppet::puppetserver::sentry_dsn),
  }
}

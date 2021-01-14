# == Class: puppet::puppetserver::sentry
#
# Installs the sentry-raven Ruby Gem into the PuppetServer and sets the
# Sentry DSN in /etc/puppet/sentry.conf.
#
class puppet::puppetserver::sentry {
  file { "${settings::confdir}/sentry.conf":
    ensure  => absent,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0400',
    content => sprintf('dsn=%s', $::puppet::puppetserver::sentry_dsn),
  }
}

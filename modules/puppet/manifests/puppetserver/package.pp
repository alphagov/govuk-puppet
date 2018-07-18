# == Class: puppet::puppetserver::package
#
# Install packages for a Puppetserver.
#
# === Parameters
#
# [*puppet_sentry_dsn*]
#   This is the DSN to send puppet reports to.
#
class puppet::puppetserver::package(
  $puppet_sentry_dsn = undef,
) {
  require '::govuk_java::openjdk7::jre'

  package { 'puppetserver':
    ensure  => installed,
  }

  package { ['aws-sdk-ec2', 'aws-sdk-core']:
    provider => system_gem,
  }

  # These gems are installed during the bootstrap, but puppetserver needs
  # gems in the jruby path
  package { ['hiera-eyaml-gpg', 'gpgme']:
    ensure   => absent,
    provider => system_gem,
  }

  exec { '/usr/bin/puppetserver gem install hiera-eyaml-gpg':
    unless  => '/usr/bin/puppetserver gem list | /bin/grep hiera-eyaml-gpg',
    require => Package['puppetserver'],
  }

  exec { '/usr/bin/puppetserver gem install ruby_gpg':
    unless  => '/usr/bin/puppetserver gem list | /bin/grep ruby_gpg',
    require => Package['puppetserver'],
  }

  exec { '/usr/bin/puppetserver gem install sentry-raven':
    unless  => '/usr/bin/puppetserver gem list | /bin/grep sentry-raven',
    require => Package['puppetserver'],
  }

  file_line { 'puppetserver_config_sentry':
    ensure  => present,
    path    => '/etc/default/puppetserver',
    line    => inline_template("PUPPET_SENTRY_DSN=${puppet_sentry_dsn}\n"),
    match   => '^PUPPET_SENTRY_DSN=',
    require => Package['puppetserver'],
  }
}

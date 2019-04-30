# == Class: puppet::puppetserver::package
#
# Install packages for a Puppetserver.
#
class puppet::puppetserver::package {
  require '::govuk_java::openjdk7::jre'

  include govuk_monit

  package { 'puppetserver':
    ensure => 'latest',
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

}

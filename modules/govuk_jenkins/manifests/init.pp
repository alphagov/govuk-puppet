# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_jenkins {
  include govuk::python
  include govuk_jenkins::ssh_key

  $jenkins_home = '/home/jenkins'
  user { 'jenkins':
    ensure     => present,
    home       => $jenkins_home,
    managehome => true,
    shell      => '/bin/bash'
  }

  # Parents created in `jenkins::ssh_key`.
  file { "${jenkins_home}/.ssh/authorized_keys":
    ensure => absent,
    owner  => 'jenkins',
    group  => 'jenkins',
    mode   => '0600',
  }

  include govuk_java::oracle7::jdk
  include govuk_java::oracle7::jre

  class { 'govuk_java::set_defaults':
    jdk => 'oracle7',
    jre => 'oracle7',
  }

  package { 'brakeman':
    ensure   => 'installed',
    provider => system_gem,
  }

  package { 'ghtools':
    ensure   => '0.20.0',
    provider => pip,
  }

  package { [
    'sqlite3',
    'gnuplot',
    'python-paramiko',
    'ant'
    ]:
      ensure => installed,
  }

  # Required for redirector-deploy
  package { 's3cmd':
    ensure   => 'installed',
    provider => 'pip',
  }

  # This is required for the redirector-deploy job
  package { 'libtext-csv-perl':
    ensure => installed,
  }

  # This is required for the redirector-integration job
  package { 'libcrypt-ssleay-perl':
    ensure => installed,
  }

  file { '/home/jenkins/.gitconfig':
    source  => 'puppet:///modules/govuk_jenkins/dot-gitconfig',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0644',
    require => User['jenkins'],
  }

  file { '/mnt/jenkins':
    ensure  => directory,
    owner   => jenkins,
    group   => jenkins,
    mode    => '0644',
    require => User['jenkins'],
  }

  file { '/var/lib/jenkins':
    ensure  => link,
    target  => '/mnt/jenkins',
    require => File['/mnt/jenkins'],
  }

  include bundler
  include govuk_mysql::libdev
  include mysql::client

  # FIXME: Remove when deployed.
  package { [
    'libffi-dev',
    'aspell',
  ]:
    ensure   => absent,
  }

  # FIXME: Remove when deployed.
  package { [
    'scrapy',
    'twisted',
    'w3lib',
    'pyOpenSSL',
    'lxml',
    'zope.interface',
    'six',
    'cryptography',
    'cffi',
    'pycparser',
  ]:
    ensure   => absent,
    provider => pip,
  }
}

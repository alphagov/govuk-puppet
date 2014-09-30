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

  apt::source { 'jenkins':
    location     => 'http://apt.production.alphagov.co.uk/jenkins',
    release      => 'binary',
    architecture => $::architecture,
    key          => '37E3ACBB',
  }

  package { 'jenkins':
    ensure  => '1.554.2',
    require => [
      Class['govuk_java::set_defaults'],
      File['/var/lib/jenkins'],
    ],
  }

  file { '/etc/default/jenkins':
    ensure  => file,
    source  => 'puppet:///modules/govuk_jenkins/etc/default/jenkins',
    require => Package['jenkins'],
  }

  service { 'jenkins':
    ensure    => 'running',
    subscribe => File['/etc/default/jenkins'],
  }

  include bundler
  include govuk_mysql::libdev
  include mysql::client

  # FIXME: Remove when deployed.
  package { [
    'libffi-dev',
    'aspell',
    'ant',
    'sqlite3',
    'gnuplot',
    'python-paramiko',
    'libtext-csv-perl',
    'libtext-csv-xs-perl',
    'libcrypt-ssleay-perl',
    'liburi-perl',
    'libwww-perl',
  ]:
    ensure   => absent,
  }

  # FIXME: Remove when deployed.
  package { [
    's3cmd',
    'ghtools',
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

  # FIXME: Remove when deployed.
  file { '/var/govuk-archive':
    ensure => absent,
    force  => true,
  }
}

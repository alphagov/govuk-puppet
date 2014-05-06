class jenkins {
  include govuk::python
  include jenkins::ssh_key

  #TODO:
  # also need to install fabric and cloth which are needed by private-utils,
  # possibly this would be better done in the private-utils/jenkins.sh

  $jenkins_home = '/home/jenkins'
  user { 'jenkins':
    ensure     => present,
    home       => $jenkins_home,
    managehome => true,
    shell      => '/bin/bash'
  }

  # Parents created in `jenkins::ssh_key`.
  # Contents overridden in `jenkins::slave`.
  file { "${jenkins_home}/.ssh/authorized_keys":
    ensure  => absent,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0600',
  }

  include govuk_java::sun6::jdk
  include govuk_java::sun6::jre

  class { 'govuk_java::set_defaults':
    jdk => 'sun6',
    jre => 'sun6',
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

  # This is required for the gov.uk spider job
  package { 'scrapy':
    ensure   => '0.14.4',
    provider => 'pip',
  }

  package { 'twisted':
    ensure   => '10.0.0',
    provider => 'pip',
  }

  file { '/home/jenkins/.gitconfig':
    source  => 'puppet:///modules/jenkins/dot-gitconfig',
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

  # Used by govuk::apps::search
  include aspell
}

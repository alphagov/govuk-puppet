class jenkins {
  #TODO:
  # also need to install fabric and cloth which are needed by private-utils,
  # possibly this would be better done in the private-utils/jenkins.sh

  user { 'jenkins':
    ensure     => present,
    home       => '/home/jenkins',
    managehome => true,
    shell      => '/bin/bash'
  }

  package { 'brakeman':
    ensure   => 'installed',
    provider => gem,
  }

  include jenkins::apache
  include jenkins::ssh_key

  package { 'sqlite3':
    ensure => installed,
  }

  file { '/home/jenkins/.gitconfig':
    source  => 'puppet:///modules/jenkins/dot-gitconfig',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0644',
    require => User['jenkins'],
  }

  file { '/home/jenkins/.ssh':
    ensure  => directory,
    owner   => jenkins,
    group   => jenkins,
    mode    => '0644',
    require => User['jenkins'],
  }

  file { '/home/jenkins/.ssh/config':
    source  => 'puppet:///modules/jenkins/dot-sshconfig',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0644',
    require => [User['jenkins'], File['/home/jenkins/.ssh']]
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
}

class jenkins::master inherits jenkins {

  apt::key{ 'Kohsuke Kawaguchi':
    ensure      => present,
    apt_key_url => 'http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key',
  }

  package { 'jenkins':
    ensure  => 'latest',
    require => [
      User['jenkins'],
      Exec['apt-key present Kohsuke Kawaguchi'],
      File['jenkins.list'],
      Exec['apt-get update'],
    ],
  }

  package { 'keychain':
    ensure => 'installed'
  }

  file { '/home/jenkins/.bashrc':
    source  => 'puppet:///modules/jenkins/dot-bashrc',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0700',
    require => Package['keychain'],
  }

  file { 'jenkins.list':
    path   => '/etc/apt/sources.list.d/jenkins.list',
    source => 'puppet:///modules/jenkins/jenkins.list',
    mode   => '0644',
    before => [
      Exec['apt-get update'],
      Exec['apt-key present Kohsuke Kawaguchi']
    ],
  }
}

class jenkins::slave inherits jenkins {
}

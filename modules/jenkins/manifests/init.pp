class jenkins {

  include jenkins::apache
  include jenkins::ssh_key

  apt::key{ 'Kohsuke Kawaguchi':
    ensure      => present,
    apt_key_url => 'http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key',
  }

  user { 'jenkins':
    ensure     => present,
    home       => '/home/jenkins',
    managehome => true,
    shell      => '/bin/bash'
  }

  file { 'jenkins.list':
    path   => '/etc/apt/sources.list.d/jenkins.list',
    source => 'puppet:///modules/jenkins/jenkins.list',
    mode   => '0644',
    before => [
      Exec['apt_update'],
      Exec['apt-key present Kohsuke Kawaguchi']
    ],
  }

  package { 'python-setuptools':
    ensure => installed,
  }
  package { 'python-dev':
    ensure => installed,
  }
  package { 'sqlite3':
    ensure => installed,
  }
  package { 'jenkins':
    ensure  => 'latest',
    require => [
      User['jenkins'],
      Exec['apt-key present Kohsuke Kawaguchi'],
      File['jenkins.list'],
      Exec['apt_update'],
    ],
  }

  package { 'keychain':
    ensure => 'installed'
  }

  file {'/home/jenkins/.bashrc':
    source  => 'puppet:///modules/jenkins/dot-bashrc',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0700',
    require => Package['keychain'],
  }

  file {'/home/jenkins/.gitconfig':
    source  => 'puppet:///modules/jenkins/dot-gitconfig',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0644',
    require => User['jenkins'],
  }
}

class jenkins {

  include jenkins::apache

  class apache {
    define a2enmod() {
      exec { "a2enmod $name":
        command => "/usr/sbin/a2enmod $name",
        unless  => "/bin/sh -c '[ -L /etc/apache2/mods-enabled/$name.load ] \\
          && [ /etc/apache2/mods-enabled/$name.load -ef /etc/apache2/mods-available/$name.load ]'",
        require => Package['apache2'],
        notify  => Exec['apache_graceful'],
      }
    }

    a2enmod { 'proxy': }
    a2enmod { 'proxy_http': }

    package { 'apache2':
      ensure => installed,
    }
    package { 'python-setuptools':
      ensure => installed,
    }
    package { 'python-dev':
      ensure => installed,
    }

    service { 'apache2':
      ensure     => running,
      hasstatus  => true,
      hasrestart => true,
      require    => Package['apache2']
    }

    file { '/etc/apache2/ports.conf':
      ensure  => present,
      content => template('apache2/ports.conf'),
      require => Package['apache2'],
      notify  => Service['apache2'],
    }

    exec { 'apache_graceful':
      command     => 'apache2ctl graceful',
      refreshonly => true,
      onlyif      => 'apache2ctl configtest',
    }

    file { '/etc/apache2/sites-available/default':
      ensure  => present,
      source  => 'puppet:///modules/jenkins/vhost',
      force   => true,
      require => [Package['apache2'], Exec['a2enmod proxy'], Exec['a2enmod proxy_http']],
      notify  => Exec['apache_graceful'],
    }

    file { '/etc/apache2/sites-available/default-ssl':
      ensure => absent,
      force  => true,
      notify => Exec['apache_graceful'],
    }
  }

  include jenkins::ssh_key

  class ssh_key {
    $private_key = '/home/jenkins/.ssh/id_rsa'
    $public_key = '/home/jenkins/.ssh/id_rsa.pub'

    file { $public_key:
      checksum => md5,
      require  => [ User['jenkins'], File['/home/jenkins/.ssh'] ],
    }

    file { '/home/jenkins/.ssh':
      ensure => directory,
      mode   => '0600',
      owner  => 'jenkins',
      group  => 'jenkins',
    }

    exec { 'Creating key pair for jenkins':
      command => "ssh-keygen -t rsa -C 'Provided by Puppet for jenkins' -N '' -f $private_key",
      creates => $private_key,
      require => [
        User['jenkins'],
        File['/home/jenkins/.ssh']
      ],
      user    => 'jenkins',
    }
  }

  apt::key{ 'jenkins-ci.org.key':
    ensure      => present,
    apt_key_url => 'http://pkg.jenkins-ci.org/debian',
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
      Exec['apt-key present jenkins-ci.org.key']
    ],
  }

  package { 'jenkins':
    ensure  => 'latest',
    require => [
      User['jenkins'],
      Exec['apt-key present jenkins-ci.org.key'],
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

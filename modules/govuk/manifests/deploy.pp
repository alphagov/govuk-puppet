class govuk::deploy {
  include bundler
  include fpm
  include python
  include pip
  include govuk::spinup

  group { 'deploy':
    ensure  => 'present',
    name    => 'deploy',
  }
  user { 'deploy':
    ensure      => present,
    home        => '/home/deploy',
    managehome  => true,
    shell       => '/bin/bash',
    gid         => 'deploy',
    require     => Group['deploy'];
  }

  file { '/data':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    require => User['deploy'],
  }
  file { '/data/vhost':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    require => File['/data'],
  }

  file { '/etc/govuk':
    ensure => directory,
  }

  ssh_authorized_key { 'deploy_key_jenkins':
    ensure  => present,
    key     => extlookup('jenkins_key', ''),
    type    => 'ssh-rsa',
    user    => 'deploy',
  }

  ssh_authorized_key { 'deploy_key_jenkins_skyscape':
    ensure  => present,
    key     => extlookup('jenkins_skyscape_key', ''),
    type    => 'ssh-rsa',
    user    => 'deploy',
  }
}

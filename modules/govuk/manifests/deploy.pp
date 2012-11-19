class govuk::deploy {

  include bundler
  include fpm
  include python
  include pip
  include envmgr
  include unicornherder
  include users::assets

  group { 'deploy':
    ensure  => 'present',
    name    => 'deploy',
  }

  user { 'deploy':
    ensure      => present,
    home        => '/home/deploy',
    managehome  => true,
    groups      => ['assets'],
    shell       => '/bin/bash',
    gid         => 'deploy',
    require     => [Group['deploy'],Group['assets']];
  }

  file { '/etc/govuk':
    ensure => directory,
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

  file { '/var/apps':
    ensure => directory,
  }

  if $::govuk_platform != 'development' {
    ssh_authorized_key { 'deploy_key_jenkins':
      ensure  => present,
      key     => extlookup('jenkins_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    }

    ssh_authorized_key { 'deploy_key_jenkins_skyscape':
      ensure  => present,
      key     => extlookup('jenkins_skyscape_key', ''),
      type    => 'ssh-rsa',
      user    => 'deploy',
    }
  }

  file { '/etc/govuk/unicorn.rb':
    ensure  => present,
    source  => 'puppet:///modules/govuk/etc/govuk/unicorn.rb',
    require => File['/etc/govuk'],
  }

  file { '/usr/local/bin/govuk_spinup':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_spinup',
    mode    => '0755',
    require => Package['envmgr'],
  }

  $app_domain = extlookup('app_domain')

  file { '/etc/govuk/app_domain':
    ensure  => present,
    content => $app_domain,
    require => File['/etc/govuk'],
  }

  $asset_root = extlookup('asset_root', "https://static.${app_domain}")

  # This file is deprecated and will be removed once the transition from
  # asset_host -> asset_root is completed.
  file { '/etc/govuk/asset_host.conf':
    ensure  => present,
    content => $asset_root,
    require => File['/etc/govuk'],
  }

  file { '/etc/govuk/asset_root':
    ensure  => present,
    content => $asset_root,
    require => File['/etc/govuk'],
  }

  # There will also be a file here called /etc/govuk/asset_host, but I don't
  # want to create it with invalid content, which it would contain until the
  # asset_host extdata variable is repurposed.

  # $asset_host = extlookup('asset_host', "static.${app_domain}")

  # file { '/etc/govuk/asset_host':
  #   ensure  => present,
  #   content => $asset_host,
  #   require => File['/etc/govuk'],
  # }
}

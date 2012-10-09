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

  $app_domain = extlookup('app_domain_suffix', 'dev.gov.uk')

  $asset_host = $::govuk_platform ? {
    'production'  => "https://d17tffe05zdvwj.cloudfront.net",
    'preview'     => "https://djb1962t8apu5.cloudfront.net",
    'development' => "http://static.${app_domain}",
    default       => "https://static.${app_domain}",
  }

  file { '/etc/govuk/asset_host.conf':
    ensure  => present,
    content => $asset_host,
    require => File['/etc/govuk'],
  }

}

class govuk::deploy {

  include assets::user
  include bundler
  include daemontools
  include fpm
  include harden
  include pip
  include python
  include virtualenv
  include unicornherder

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

  harden::limit { 'deploy-nofile':
    domain => 'deploy',
    type   => '-', # set both hard and soft limits
    item   => 'nofile',
    value  => '16384',
  }

  file { '/etc/govuk':
    ensure => directory,
  }

  file { '/var/lib/govuk':
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
      key     => extlookup('jenkins_key', 'NO_KEY_IN_EXTDATA'),
      type    => 'ssh-rsa',
      user    => 'deploy',
      require => User['deploy'];
    }

    ssh_authorized_key { 'deploy_key_jenkins_skyscape':
      ensure  => present,
      key     => extlookup('jenkins_skyscape_key', 'NO_KEY_IN_EXTDATA'),
      type    => 'ssh-rsa',
      user    => 'deploy',
    }
    # This key is required to allow Production Jenkins to sync data to
    # other environments.
    ssh_authorized_key { 'deploy_key_jenkins_skyscape_production':
      ensure  => present,
      key     => extlookup('jenkins_skyscape_production_key', 'NO_KEY_IN_EXTDATA'),
      type    => 'ssh-rsa',
      user    => 'deploy',
    }
  }

  $deploy_user_data_sync_key = extlookup('deploy_user_data_sync_key', 'NONE')

  if $deploy_user_data_sync_key != 'NONE' {
    ssh_authorized_key { 'data_sync_key':
      ensure  => present,
      key     => $deploy_user_data_sync_key,
      type    => 'ssh-rsa',
      user    => 'deploy',
    }
  }

  file { '/etc/govuk/unicorn.rb':
    ensure  => present,
    source  => 'puppet:///modules/govuk/etc/govuk/unicorn.rb',
    require => File['/etc/govuk'],
  }

  # govuk_spinup is a wrapper script used to start up apps that form part of
  # the GOV.UK stack. It exports various environment variables used by
  # Rails/A. N. Other Application Framework, and starts up either
  # Procfile-based or unicorn applications.
  file { '/usr/local/bin/govuk_spinup':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_spinup',
    mode    => '0755',
  }

  # govuk_setenv is a simple script that loads the environment for a GOV.UK
  # application and execs its arguments
  # daemontools provides envdir, used by govuk_setenv
  file { '/usr/local/bin/govuk_setenv':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_setenv',
    mode    => '0755',
    require => Class['daemontools'],
  }

  # /etc/govuk/env.d is an envdir. Each file and its contents should denote
  # the name and value of an environment variable that should be exported
  file { '/etc/govuk/env.d':
    ensure  => directory,
    purge   => true,
    recurse => true,
    force   => true,
    require => File['/etc/govuk'],
  }

  $app_domain = extlookup('app_domain')

  govuk::envvar { 'GOVUK_APP_DOMAIN':
    value => $app_domain,
  }

  $asset_root = extlookup('asset_root', "https://static.${app_domain}")

  # This file is deprecated and will be removed once the transition from
  # asset_host -> asset_root is completed.
  file { '/etc/govuk/asset_host.conf':
    ensure  => present,
    content => $asset_root,
    require => File['/etc/govuk'],
  }

  govuk::envvar { 'GOVUK_ASSET_ROOT':
    value => $asset_root,
  }

  $website_root = extlookup('website_root')

  govuk::envvar { 'GOVUK_WEBSITE_ROOT':
    value => $website_root,
  }

  # I don't want to create the following with invalid content, which it would
  # contain until the asset_host extdata variable is repurposed. Commented out
  # until the transition from asset_host -> asset_root has occurred in
  # extdata.

  # $asset_host = extlookup('asset_host', "static.${app_domain}")

  # govuk::envvar { 'GOVUK_ASSET_HOST':
  #   value => $asset_host,
  # }

  govuk::envvar { 'GOVUK_ASSET_HOST':
    value => $asset_root,
  }

  $govuk_env = extlookup('govuk_env', 'production')
  govuk::envvar {
    'GOVUK_ENV': value => $govuk_env;
    'RAILS_ENV': value => $govuk_env;
    'RACK_ENV':  value => $govuk_env;
  }

  # tagalog provides logship, used by govuk_logpipe
  package { 'tagalog':
    ensure   => '0.2.4',
    provider => 'pip',
  }

  # govuk_logpipe pipes application logs
  file { '/usr/local/bin/govuk_logpipe':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_logpipe',
    mode    => '0755',
    require => Package['tagalog'],
  }
}

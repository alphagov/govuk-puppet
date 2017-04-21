# == Class: govuk::deploy::setup
#
# Setup resources required by apps. The variation of these resources should
# not require an app to be restarted. Compared to `govuk::deploy::config`.
#
# === Parameters
#
# [*setup_actionmailer_ses_config*]
# [*actionmailer_enable_delivery*]
#   Determines whether email deliveries are enabled in the ActionMailer config.
#
# [*aws_ses_smtp_host*]
# [*aws_ses_smtp_username*]
# [*aws_ses_smtp_host*]
#
# [*ssh_keys*]
#   Hash of SSH authorized_keys entries to allow deployments from.
#
class govuk::deploy::setup (
    $setup_actionmailer_ses_config,
    $actionmailer_enable_delivery,
    $aws_ses_smtp_host,
    $aws_ses_smtp_username,
    $aws_ses_smtp_password,
    $gemstash_server = 'http://gemstash.cluster',
    $ssh_keys = { 'not set in hiera' => 'NONE_IN_HIERA' },
){
  validate_hash($ssh_keys)

  include assets::group

  group { 'deploy':
    ensure => 'present',
    name   => 'deploy',
  }

  user { 'deploy':
    ensure     => present,
    home       => '/home/deploy',
    managehome => true,
    groups     => ['assets'],
    shell      => '/bin/bash',
    gid        => 'deploy',
    require    => [Group['deploy'],Group['assets']];
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

  file { '/data/apps':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    require => File['/data'],
  }

  file { '/var/apps':
    ensure => directory,
  }

  file { '/home/deploy/.ssh':
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy',
    mode   => '0700',
  }

  file { '/home/deploy/.ssh/authorized_keys':
    ensure  => present,
    owner   => 'deploy',
    group   => 'deploy',
    mode    => '0600',
    content => template('govuk/home/deploy/.ssh/authorized_keys.erb'),
  }

  if ($setup_actionmailer_ses_config) {
    file { '/etc/govuk/actionmailer_ses_smtp_config.rb':
      ensure  => present,
      content => template('govuk/etc/govuk/actionmailer_ses_smtp_config.erb'),
      require => File['/etc/govuk'],
    }
  }

  govuk_bundler::config { 'deploy-bundler':
    server    => $gemstash_server,
    require   => User['deploy'],
    user_home => '/home/deploy',
  }
}

# == Class: govuk::deploy::setup
#
# Setup resources required by apps. The variation of these resources should
# not require an app to be restarted. Compared to `govuk::deploy::config`.
#
# === Parameters
#
# [*ssh_keys*]
#   Hash of SSH authorized_keys entries to allow deployments from.
#
# [*deploy_uid*]
#   Deploy UID
#
# [*deploy_gid*]
#   Deploy GID
class govuk::deploy::setup (
    $gemstash_server = 'http://gemstash.cluster',
    $ssh_keys = { 'not set in hiera' => 'NONE_IN_HIERA' },
    $deploy_uid = undef,
    $deploy_gid = undef,
){
  validate_hash($ssh_keys)
  require  backup::client

  if $::aws_migration {
    include govuk::deploy::sync

    $deploy_groups = ['govuk-backup']
  } else {
    include assets::group

    $deploy_groups = ['assets','govuk-backup']
    Group['assets','govuk-backup'] -> User['deploy']
  }

  group { 'deploy':
    ensure => 'present',
    name   => 'deploy',
    gid    => $deploy_gid,
  }

  user { 'deploy':
    ensure     => present,
    home       => '/home/deploy',
    managehome => true,
    groups     => $deploy_groups,
    shell      => '/bin/bash',
    uid        => $deploy_uid,
    gid        => 'deploy',
    require    => Group['deploy'],
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

  govuk_bundler::config { 'deploy-bundler':
    server    => $gemstash_server,
    require   => User['deploy'],
    user_home => '/home/deploy',
    username  => 'deploy',
  }
}

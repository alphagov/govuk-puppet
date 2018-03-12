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
# [*deploy_uid*]
#   Deploy UID
#
# [*deploy_gid*]
#   Deploy GID
class govuk::deploy::setup (
    $setup_actionmailer_ses_config,
    $actionmailer_enable_delivery,
    $aws_ses_smtp_host,
    $aws_ses_smtp_username,
    $aws_ses_smtp_password,
    $gemstash_server = 'http://gemstash.cluster',
    $ssh_keys = { 'not set in hiera' => 'NONE_IN_HIERA' },
    $deploy_uid = undef,
    $deploy_gid = undef,
    $assets_aws_s3_bucket_name = undef,
    $assets_aws_access_key_id = undef,
    $assets_aws_secret_access_key = undef,
){
  validate_hash($ssh_keys)

  if $::aws_migration {
    include govuk::deploy::sync

    $deploy_groups = []
  } else {
    include assets::group

    $deploy_groups = ['assets']
    Group['assets'] -> User['deploy']
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
    username  => 'deploy',
  }

  # After deploy, frontend apps will upload their assets to S3
  package { 's3cmd':
    ensure   => 'present',
    provider => 'pip',
  }

  govuk::app::envvar {
    "${title}-ASSETS_AWS_S3_BUCKET":
      varname => 'ASSETS_AWS_S3_BUCKET_NAME',
      value   => $assets_aws_s3_bucket_name;
    "${title}-ASSETS_AWS_ACCESS_KEY":
      varname => 'ASSETS_AWS_ACCESS_KEY',
      value   => $assets_aws_access_key_id;
    "${title}-ASSETS_AWS_SECRET_KEY":
      varname => 'ASSETS_AWS_SECRET_KEY',
      value   => $assets_aws_secret_access_key;
  }
}

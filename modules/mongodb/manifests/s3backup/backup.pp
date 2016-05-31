# == Class: mongodb::s3backup::backup
#
# Backup a MongoDB server to AWS S3
#
# === Parameters:
#
# [*aws_access_key_id*]
#
# [*aws_secret_access_key*]
#
# [*aws_region*]
#   AWS region for the S3 bucket
#
# [*backup_dir*]
#   Defines the directory to dump the backups
#
# [*cron*]
#   Defines whether to enable the cron job. Value
#   should be true or false
#
# [*backup_node*]
#   Defines the host where the backup will 
#   take place
#
# [*private_gpg_key*]
#   Defines the ascii exported private gpg to
#   use for encrypting backups. This key should
#   be created by the user and encrypted with eyaml
#
# [*private_gpg_key_fingerprint*]
#   Defines the fingerprint of the gpg private
#   key to encrypt the backups. The fingerprint
#   should be 40 characters without spaces
#
# [*s3_bucket*]
#   Defines the AWS S3 bucket where the backups
#   will be uploaded. It should be created by the
#   user
#
# [*standalone*]
#   If true, will backup localhost instead of a
#   Secondary
#
class mongodb::s3backup::backup(
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_region = 'eu-west-1',
  $backup_dir = '/var/lib/s3backup',
  $backup_node = undef,
  $cron = true,
  $private_gpg_key = undef,
  $private_gpg_key_fingerprint,
  $s3_bucket  = 'govuk-mongodb-backup-s3',
  $standalone  = False,
  ){

  validate_re($private_gpg_key_fingerprint, '^[[:alnum:]]{40}$', 'Must supply full GPG fingerprint')

  include backup::client
  $backup_user = 'govuk-backup'

  File {
    owner => $backup_user,
    group => $backup_user,
    mode  => '0660',
  }

  # push scripts
  file { '/usr/local/bin/mongodb-backup-s3':
    ensure  => present,
    content => template('mongodb/mongodb-backup-s3.erb'),
    mode    => '0750',
    require => User[$backup_user],
  }

  file { '/usr/local/bin/mongodb-backup-s3-wrapper':
    ensure  => present,
    content => template('mongodb/mongodb-backup-s3-wrapper.erb'),
    mode    => '0755',
    require => User[$backup_user],
  }

  # push gpg key
  file { "/home/${backup_user}/.gnupg":
    ensure => directory,
    mode   => '0700',
  }

  file { "/home/${backup_user}/.gnupg/gpg.conf":
    ensure  => present,
    content => 'trust-model always',
    mode    => '0600',
  }

  file { "/home/${backup_user}/.gnupg/${private_gpg_key_fingerprint}_secret_key.asc":
    ensure  => present,
    mode    => '0600',
    content => $private_gpg_key,
  }

  # import key
  exec { "import_gpg_secret_key_${::hostname}":
    command     => "gpg --batch --delete-secret-and-public-key ${private_gpg_key_fingerprint}; gpg --allow-secret-key-import --import /home/${backup_user}/.gnupg/${private_gpg_key_fingerprint}_secret_key.asc",
    user        => $backup_user,
    group       => $backup_user,
    subscribe   => File["/home/${backup_user}/.gnupg/${private_gpg_key_fingerprint}_secret_key.asc"],
    refreshonly => true,
  }

  class { 'mongodb::s3backup::cron':
    user => $backup_user,
  }

  # monitoring
  $threshold_secs = 28 * 3600
  $service_desc = 'Mongodb s3backup'

  @@icinga::passive_check { "check_mongodb_s3backup-${::hostname}":
    service_description => $service_desc,
    freshness_threshold => $threshold_secs,
    host_name           => $::fqdn,
  }

}

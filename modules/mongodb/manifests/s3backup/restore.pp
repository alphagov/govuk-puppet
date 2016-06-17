# == Class: mongodb::s3backup::restore
#
# Restore a MongoDB backup to a server from s3
#
# === Parameters:
#
# [*aws_access_key_id*]
#
# [*aws_secret_access_key*]
#
# [*backup_dir*]
#   Defines the directory to restore the backups
#
# [*env_dir*]
#   Defines directory for the environment
#   variables
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
# [*cron*]
#   Defines whether to enable the cron job. Value
#   should be true or false
class mongodb::s3backup::restore(
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $env_dir = '/etc/mongo_s3backup',
  $s3_bucket  = 'govuk-mongodb-backup-s3',
  $backup_dir = '/var/lib/s3backup',
  $user = backup::client::govuk-backup,
  $cron = false
){
  include backup::client

  file { '/usr/local/bin/mongodb-restore-s3':
    ensure  => file,
    content => template('mongodb/mongodb-restore-s3.erb'),
    mode    => '0770',
    owner   => $user,
    group   => $user,
  }

}
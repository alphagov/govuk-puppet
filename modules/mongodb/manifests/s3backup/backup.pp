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
# [*server*]
#   Defines the server to connect to. The backup
#   script will pick a secondary to backup, unless
#   'standalone' is 'True'
#
# [*standalone*]
#   If true, will backup localhost instead of a
#   Secondary
#
# [*user*]
#   Defines the system user that will be created
#   to run the backups

class mongodb::s3backup::backup(
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_region = 'eu-west-1',
  $backup_dir = '/var/lib/s3backup',
  $cron = true,
  $env_dir = '/etc/mongo_s3backup',
  $private_gpg_key = undef,
  $private_gpg_key_fingerprint,
  $s3_bucket  = 'govuk-mongodb-backup-s3',
  $server = 'localhost',
  $standalone = false,
  $user = 'govuk-backups'
  ){

  validate_re($private_gpg_key_fingerprint, '^[[:alnum:]]{40}$', 'Must supply full GPG fingerprint')

# create user
  user { $user:
    ensure     => 'present',
    managehome => true,
  }

# push env files
  file { [$env_dir,"${env_dir}/env.d"]:
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0770',
  }

    file { "${env_dir}/env.d/AWS_SECRET_ACCESS_KEY":
      content => $aws_secret_access_key,
      owner   => $user,
      group   => $user,
      mode    => '0660',
    }

    file { "${env_dir}/env.d/AWS_ACCESS_KEY_ID":
      content => $aws_access_key_id,
      owner   => $user,
      group   => $user,
      mode    => '0640',
    }

    file { "${env_dir}/env.d/AWS_REGION":
      content => $aws_region,
      owner   => $user,
      group   => $user,
      mode    => '0640',
    }

  # push scripts
  file { '/usr/local/bin/mongodb-backup-s3':
    ensure  => present,
    content => template('mongodb/mongodb-backup-s3.erb'),
    owner   => $user,
    group   => $user,
    mode    => '0755',
    require => User[$user],
  }

  file { '/usr/local/bin/mongodb-backup-s3-wrapper':
    ensure  => present,
    content => template('mongodb/mongodb-backup-s3-wrapper.erb'),
    owner   => $user,
    group   => $user,
    mode    => '0755',
    require => User[$user],
  }

  file { $backup_dir:
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0750',
  }

  # push gpg key
  file { "/home/${user}/.gnupg":
    ensure => directory,
    mode   => '0700',
    owner  => $user,
    group  => $user,
  }

  file { "/home/${user}/.gnupg/gpg.conf":
    ensure  => present,
    content => 'trust-model always',
    mode    => '0600',
    owner   => $user,
    group   => $user,
  }

  file { "/home/${user}/.gnupg/${private_gpg_key_fingerprint}_secret_key.asc":
    ensure  => present,
    mode    => '0600',
    content => $private_gpg_key,
    owner   => $user,
    group   => $user,
  }

  # import key
  exec { 'import_gpg_secret_key':
    command     => "gpg --batch --delete-secret-and-public-key ${private_gpg_key_fingerprint}; gpg --allow-secret-key-import --import /home/${user}/.gnupg/${private_gpg_key_fingerprint}_secret_key.asc",
    user        => $user,
    group       => $user,
    subscribe   => File["/home/${user}/.gnupg/${private_gpg_key_fingerprint}_secret_key.asc"],
    refreshonly => true,
  }

  # cron
  include mongodb::s3backup::cron

  # monitoring
  $threshold_secs = 28 * 3600
  $service_desc = 'Mongodb s3backup'

  @@icinga::passive_check { "check_mongodb_s3backup-${::hostname}":
    service_description => $service_desc,
    freshness_threshold => $threshold_secs,
    host_name           => $::fqdn,
  }

}

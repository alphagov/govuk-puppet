# == Class: govuk_elasticsearch::backup
#
# GOV.UK specific class to backup elasticsearch indexes.
#
# === Parameters
#
# [*aws_access_key_id*]
#   AWS key to authenticate requests
#
# [*aws_secret_access_key*]
#   AWS key to authenticate requests
#
# [*aws_region*]
#   AWS region for the S3 bucket
#
# [*env_dir*]
#   Defines directory for the environment
#   variables
#
# [*s3_bucket*]
#   Defines the AWS S3 bucket where the backups
#   will be uploaded. It should be created by the
#   user
#
# [*user*]
#   Defines the system user that will be created
#   to run the backups
#
# [*es_repo*]
#   The repository within elasticsearch
#   where backups will be stored
#
# [*es_indices*]
#   Elaticsearch indexes
#
# [*enabled*]
#   Determines whether this job will be scheduled
#
class govuk_elasticsearch::backup(
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_region = 'eu-west-1',
  $s3_bucket = undef,
  $cron = true,
  $env_dir = '/etc/es_s3backup',
  $user = 'govuk-backup',
  $es_repo = undef,
  $enabled = false,
  $es_indices = [
    join(regsubst($govuk_elasticsearch::backup::es_indices, '.*', '"\1"'), ',')]
  ){

  include backup::client
  include govuk_elasticsearch::housekeeping


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
      mode    => '0640',
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

    file { 'es-backup-s3':
      path    => '/usr/local/bin',
      owner   => $user,
      group   => $user,
      mode    => '0550',
      content => template('govuk_elasticsearch/es-backup-s3.erb'),
    }

  # Remove cron job if backup is not enabled
    if $enabled {

      cron { 's3-elasticsearch-indexes':
        ensure  => present,
        command => '/usr/local/bin/es-backup-s3',
        user    => $user,
        hour    => 0,
        minute  => 0,
      }
    }
    else {

      cron { 's3-elasticsearch-indexes':
        ensure  => absent,
      }
    }
}


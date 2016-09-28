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
# [*es_repos*]
#   The repositories within elasticsearch
#   where backups will be stored
#
# [*es_indices*]
#   Elaticsearch indexes
#
# === Variables
#
# [*json_es_indices*]
#   Formatted indexes to be backed up when script is invoked
#
class govuk_elasticsearch::backup(
  $aws_access_key_id,
  $aws_secret_access_key,
  $aws_region = 'eu-west-1',
  $s3_bucket,
  $aws_source_file = '/etc/awspasswd',
  $user = 'govuk-backup',
  $es_repo = undef,
  $es_indices = []
){


    $threshold_secs = 28 * 3600
    $service_desc = 'Elasticsearch-Index_Backup'
    $json_es_indices = join(regsubst($es_indices, '(.*)', '"\1"'), ',')

    include ::backup::client
    include govuk_elasticsearch::housekeeping

    file { $aws_source_file:
      ensure  => present,
      owner   => $user,
      group   => $user,
      mode    => '0640',
      content => template('govuk_elasticsearch/awspasswd.erb'),
    }

    @@icinga::passive_check { "check_esindexbackup-${::hostname}":
      service_description => $service_desc,
      freshness_threshold => $threshold_secs,
      host_name           => $::fqdn,
    }

    file { 'es-backup-s3':
      path    => '/usr/local/bin/es-backup-s3',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('govuk_elasticsearch/es-backup-s3.erb'),
    }


    cron { 's3-elasticsearch-indexes':
      ensure  => present,
      command => '/usr/local/bin/es-backup-s3',
      user    => $user,
      hour    => 0,
      minute  => 0,
    }


    file { 'es-restore-s3':
      path    => '/usr/local/bin/es-restore-s3',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('govuk_elasticsearch/es-restore-s3.erb'),
    }

}

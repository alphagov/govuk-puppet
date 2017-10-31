# == Class: govuk_elasticsearch::backup
#
# GOV.UK specific class to backup elasticsearch indexes.
#
# === Parameters
#
# [*s3_bucket*]
#   Defines the AWS S3 bucket where the backups will be uploaded.
#
# [*ensure*]
#   Whether to create the resources.
#
# [*aws_access_key_id*]
#   AWS key to authenticate requests.
#
# [*aws_secret_access_key*]
#   AWS key to authenticate requests.
#
# [*aws_region*]
#   AWS region for the S3 bucket.
#
# [*es_repo*]
#   The repositories within elasticsearch where backups will be stored.
#
# [*es_indices*]
#   Which Elasticsearch indices to back-up.
#
# [*base_path*]
#   The base path (prefix) set for the object.
#
# [*backup_cron_hour*]
#   The hour at which the backups run.
#
# [*backup_cron_minute*]
#   The minute at which the backup runs.
#
# [*prune_cron_hour*]
#   The hour at which the prune runs.
#
# [*prune_cron_minute*]
#   The minute at which the prune runs.
#
class govuk_elasticsearch::backup (
  $s3_bucket,
  $ensure = 'present',
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_region = 'eu-west-1',
  $es_repo = 'snapshots',
  $es_indices = [],
  $base_path = 'elasticsearch',
  $backup_cron_hour = 0,
  $backup_cron_minute = 0,
  $prune_cron_hour = 4,
  $prune_cron_minute = 0,
  $prune_snapshots_to_keep = 7,
  $alert_hostname = 'alert.cluster',
){

  $threshold_secs = 28 * 3600
  $service_desc = 'Elasticsearch index snapshots'
  $json_es_indices = join(regsubst($es_indices, '(.*)', '"\1"'), ',')

  ensure_packages(['jq'])

  @@icinga::passive_check { "check_es-backup-s3-${::hostname}":
    ensure              => $ensure,
    service_description => $service_desc,
    freshness_threshold => $threshold_secs,
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(backup-passive-checks),
  }

  file { '/usr/local/bin/es-backup-s3':
    ensure  => $ensure,
    mode    => '0755',
    content => template('govuk_elasticsearch/es-backup-s3.erb'),
  }

  cron::crondotdee { 'es-backup-s3':
    ensure  => $ensure,
    command => '/usr/local/bin/es-backup-s3',
    hour    => $backup_cron_hour,
    minute  => $backup_cron_minute,
  }

  file { '/usr/local/bin/es-restore-s3':
    ensure  => $ensure,
    mode    => '0755',
    content => template('govuk_elasticsearch/es-restore-s3.erb'),
  }

  file { '/usr/local/bin/es-prune-snapshots':
    ensure  => $ensure,
    content => template('govuk_elasticsearch/es-prune-snapshots.erb'),
    mode    => '0755',
  }

  cron::crondotdee { 'es-prune-snapshots':
    ensure  => $ensure,
    command => '/usr/local/bin/es-prune-snapshots',
    hour    => $prune_cron_hour,
    minute  => $prune_cron_minute,
  }
}

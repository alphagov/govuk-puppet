# == Class: mongodb::aws_backup
#
# This class handles daily backups from MongoDB to AWS S3.
#
# === Parameters:
#
# [*ensure*]
#   Set to false to remove all resources.
#
# [*bucket*]
#   Name of the bucket to backup to.
#
class mongodb::aws_backup (
  $ensure     = 'absent',
  $backup_dir = '/var/lib/mongodb/backup',
  $bucket     = undef,
) {

  $alert_hostname = 'alert'
  $threshold_secs = 129600 # 36 hours
  $service_desc = 'MongoDB backup to S3'

  if $ensure == 'present' {
    $ensure_dir = 'directory'
  } else {
    $ensure_dir = 'absent'
  }

  if ($ensure == 'present' and $bucket) {
    $_ensure = 'present'
  } else {
    $_ensure = 'absent'
  }

  file { $backup_dir:
    ensure => $ensure_dir,
  }

  file { '/usr/local/bin/mongodump-to-s3':
    ensure  => $_ensure,
    content => template('mongodb/mongodump-to-s3.erb'),
    mode    => '0755',
    require => File[$backup_dir],
  }

  cron::crondotdee { 'mongodump-to-s3':
    ensure  => $_ensure,
    command => '/usr/bin/setlock -n /var/run/mongodump-to-s3 /usr/local/bin/mongodump-to-s3',
    hour    => '8',
    minute  => '0',
    require => File['/usr/local/bin/mongodump-to-s3'],
  }

  if ($_ensure == 'present') {
    @@icinga::passive_check { "check-mongodb-backup-to-s3-${::hostname}":
      ensure              => $_ensure,
      service_description => $service_desc,
      freshness_threshold => $threshold_secs,
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(backup-passive-checks),
    }
  }
}

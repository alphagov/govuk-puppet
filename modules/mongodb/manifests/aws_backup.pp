# == Class: mongodb::aws_backup
#
# This class handles everything related to regular backups
# in AWS. While it's similar to the current MongoDB to S3 backups,
# there are enough differences to create a new, simpler class.
#
# === Parameters:
#
# [*ensure*]
#   Set to false to remove all resources.
#
# [*bucket*]
#   Name of the bucket to backup to.
#
# [*interval*]
#   How often backups should be taken in minutes.
#
# [*daily_time*]
#   What time signifies that a backup is for long-term storage.
#   Format: <hour>:<minute>
#
class mongodb::aws_backup (
  $ensure     = 'present',
  $backup_dir = '/var/lib/mongodb/backup',
  $bucket     = undef,
  $interval   = 30,
  $daily_time = '00:00',
) {

  validate_integer($interval)
  validate_re($daily_time, '^(\d\d):(\d\d)$')

  $alert_hostname = 'alert'
  $threshold_secs = 21600
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
    hour    => '*',
    minute  => "*/${interval}",
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

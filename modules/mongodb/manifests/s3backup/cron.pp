# == Class: mongodb::s3backup::cron
#
# Runs a backup of MongoDB to Amazon S3 as a cron job.
#
# [*user*]
#   The user to run the cronjob as.
#
# [*backup_type*]
#   Type of backup to run, daily or incremental.
#
# [*hour*]
#   The hour specifier the cornjob should run at
#
# [*minute*]
#   The minute specifier the cornjob should run at
#
class mongodb::s3backup::cron(
  $backup_type = 'daily',
  $user        = 'govuk-backup',
  $hour        = '*',
  $minute      = '*/15',
) {

  include ::backup::client
  require mongodb::s3backup::package
  require mongodb::s3backup::backup

  cron { "mongodb-s3backup-${backup_type}":
    command => "/usr/bin/ionice -c 2 -n 6 /usr/bin/setlock -n /etc/unattended-reboot/no-reboot/mongodb-s3backup /usr/local/bin/mongodb-backup-s3 ${backup_type}",
    user    => $user,
    hour    => $hour,
    minute  => $minute,
  }


  # remove old cronjobs
  cron { 'mongodb-s3backup-realtime':
    ensure => 'absent',
    user   => $user,
  }

  cron { 'mongodb-s3-night-backup':
    ensure => 'absent',
    user   => $user,
  }

}

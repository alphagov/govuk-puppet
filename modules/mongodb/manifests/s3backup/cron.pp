# == Class: mongodb::s3backup::cron
#
# Runs a backup of MongoDB to Amazon S3 as a cron job.
#
# [*user*]
#   The user to run the cronjob as.
#
class mongodb::s3backup::cron(
  $user = mongodb::s3backup::backup::user
) {

  require mongodb::s3backup::package
  require mongodb::s3backup::backup

  cron { 'mongodb-s3backup':
    command => '/usr/local/bin/mongodb-backup-s3',
    user    => $user,
    minute  => '*/15',
  }

  cron { 'mongodb-s3-night-backup':
    command => '/usr/local/bin/mongodb-backup-s3',
    user    => $user,
    hour    => '0',
  }

}

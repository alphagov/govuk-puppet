# == Class: mongodb::s3backup::cron
#
# Runs a backup of MongoDB to Amazon S3 as a cron job.
#
# [*user*]
#   The user to run the cronjob as.
#
class mongodb::s3backup::cron (
  $user,
) {

  cron { 'mongodb-s3backup':
    command => '/usr/local/bin/mongodb-backup-s3-wrapper',
    user    => $user,
    minute  => '*/15',
    require => [Class['mongodb::s3backup::package'],Class['mongodb::s3backup::backup']],
  }

}

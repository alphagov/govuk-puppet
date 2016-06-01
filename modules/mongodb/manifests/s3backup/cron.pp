#
class mongodb::s3backup::cron {

  cron { 'mongodb-s3backup':
    command => '/usr/local/bin/mongodb-backup-s3-wrapper',
    user    => $mongodb::s3backup::backup::user,
    minute  => '*/15',
    require => [Class['mongodb::s3backup::package'],Class['mongodb::s3backup::backup']],
  }

}

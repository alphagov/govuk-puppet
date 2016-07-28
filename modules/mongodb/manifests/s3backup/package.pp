# == Class: mongodb::s3backup::package
#
# Installs packages required for MongoDB S3 backups
#
class mongodb::s3backup::package {



  package { 's3cmd' :
    ensure   => present,
    provider => pip,
  }

}

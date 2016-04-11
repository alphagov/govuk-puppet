#
class mongodb::s3backup::package {

  $packages = ['boto3', 'python-dateutil', 'simplejson']

  package { $packages:
    ensure   => present,
    provider => pip,
  }

}

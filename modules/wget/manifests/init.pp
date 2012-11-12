class wget {

  # wget v1.14 is provided by the GDS Packages repository
  include govuk::repository

  case $::lsbdistcodename {
    'precise': {
      # From mainline Ubuntu package repositories. This must be hard-coded in
      # order to prevent apt from bringing in the version from the GDS
      # Packages repository which links against openssl=0.9.8
      $version = '1.13.4-2ubuntu1'
    }
    default: {
      # From GDS Packages repository
      $version = '1.14'
    }
  }

  package { 'wget':
    ensure => $version,
  }

}

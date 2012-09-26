class wget {

  # wget v1.14 is provided by the GDS Packages repository
  include govuk::repository

  package { 'wget':
    ensure => '1.14',
  }

}

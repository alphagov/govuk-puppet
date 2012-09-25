class wget {

  # wget v0.14 is provided by the GDS Packages repository
  include govuk::repository

  package { 'wget':
    ensure => '0.14',
  }

}

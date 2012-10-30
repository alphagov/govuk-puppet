class postgres::package {

  include govuk::ppa

  package { 'postgresql-9.1':
    ensure => present,
  }

}

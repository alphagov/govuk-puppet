class mongodb::package {
  include mongodb::repository

  package { 'mongodb20-10gen':
    ensure => installed
  }
}

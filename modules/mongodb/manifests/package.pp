class mongodb::package {
  include mongodb::repository

  package { 'mongodb-10gen':
    ensure => installed
  }
}

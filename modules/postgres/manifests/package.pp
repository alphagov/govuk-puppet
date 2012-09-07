class postgres::package {

  include postgres::repository

  package { 'postgresql-9.1':
    ensure => present,
  }

}

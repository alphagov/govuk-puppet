class postgres::postgis {

  include postgres::repository

  package { 'postgis':
    ensure => present,
  }

  package { 'postgresql-9.1-postgis':
    ensure => present,
  }

}

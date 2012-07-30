class apache2::package {
  package { 'apache2':
    ensure => installed,
  }
}

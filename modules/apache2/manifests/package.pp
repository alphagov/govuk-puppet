class apache2::package {
  package { 'apache2':
    ensure => installed,
  }

  apache2::a2enmod { 'headers': }
  apache2::a2dismod { 'status': }
}

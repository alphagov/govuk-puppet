class apache2::install {
  package { 'apache2':
    ensure => installed,
  }

  apache2::a2enmod { 'headers': }
  apache2::a2dismod { 'status': }
}

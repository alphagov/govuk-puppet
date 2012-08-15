class nodejs {
  package { 'nodejs':
    ensure  => '0.8.2',
    require => Apt::Deb_repository['gds'],
  }
}

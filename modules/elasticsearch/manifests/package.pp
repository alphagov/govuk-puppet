class elasticsearch::package {
  include govuk::repository

  package {'elasticsearch':
    ensure  => present,
    require => Apt::Deb_repository['gds']
  }
}

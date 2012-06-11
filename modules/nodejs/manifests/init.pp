class nodejs {
  include govuk::repository
  package { 'nodejs':
    ensure  => installed,
    require => Class['govuk::repository'],
  }
}

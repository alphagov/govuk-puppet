class elasticsearch::package {
  include govuk::repository

  package {'elasticsearch'
    ensure => present
  }
}

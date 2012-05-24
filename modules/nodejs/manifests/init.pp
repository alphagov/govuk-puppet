class nodejs {
  include govuk::repository
  package { 'nodejs': ensure => installed }
}

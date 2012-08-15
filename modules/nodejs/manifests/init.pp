class nodejs {
  include govuk::repository
  package { 'nodejs':
    ensure => '0.8.2';
  }
}

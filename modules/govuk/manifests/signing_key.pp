class govuk::signing_key {
  include apt
  apt::key { 'Government Digital Service':
    ensure      => present,
    apt_key_url => 'https://github.com/downloads/alphagov/packages/gds.asc',
  }
}

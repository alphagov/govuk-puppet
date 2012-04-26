class govuk::repository {
  include apt
  include govuk::signing_key

  apt::deb_repository { 'gds':
    url     => 'http://gds-packages.s3-website-us-east-1.amazonaws.com',
    dist    => 'current',
    repo    => 'main',
    require => Class['govuk::signing_key'],
  }
}

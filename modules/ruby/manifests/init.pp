class ruby($version) {

  include govuk::ppa

  package { ['ruby1.9.1', 'ruby1.9.1-dev']:
    ensure => $version,
  }

  package { 'ruby1.8':
    ensure => purged
  }

}

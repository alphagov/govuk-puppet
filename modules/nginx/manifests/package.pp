class nginx::package {

  include govuk::ppa

  case $::lsbdistcodename {
    'precise': {
      $version = '1.4.1-1ppa0~precise'
    }
    default: {
      $version = '1.4.1-1ppa0~lucid'
    }
  }

  package { 'nginx':
    ensure => $version,
    notify => Class['nginx::restart'],
  }

}

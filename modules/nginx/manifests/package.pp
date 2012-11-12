class nginx::package {

  include govuk::ppa

  case $::lsbdistcodename {
    'precise': {
      $version = '1.2.4-2ubuntu0ppa1~precise'
    }
    default: {
      $version = '1.2.4-2ubuntu0ppa4~lucid'
    }
  }

  package { 'nginx':
    ensure => $version,
    notify => Class['nginx::restart'],
  }

}

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

  # nginx package actually has nothing useful in it; we need nginx-full
  package { 'nginx':
    ensure => purged,
  }

  package { 'nginx-full':
    ensure => $version,
    notify => Class['nginx::restart'],
  }

}

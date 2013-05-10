class nginx::package {

  include govuk::ppa

  apt::repository { 'nginx':
    owner => 'nginx',
    repo  => 'stable',
    type  => 'ppa',
  }

  case $::lsbdistcodename {
    'precise': {
      $version = '1.4.1-1ppa0~precise'
    }
    default: {
      $version = '1.4.1-1ppa1~precise'
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

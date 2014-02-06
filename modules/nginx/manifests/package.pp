class nginx::package {

  include govuk::ppa

  #FIXME: in platform one we will be all precise so this can be removed
  case $::lsbdistcodename {
    'precise': {
      $version = '1.4.4-1~precise0'
    }
    default: {
      $version = '1.4.1-1ppa1~lucid'
    }
  }

  # nginx package actually has nothing useful in it; we need nginx-full
  package { 'nginx':
    ensure => purged,
  }

  package { 'nginx-common':
    ensure => $version,
    notify => Class['nginx::restart'],
  }

  package { 'nginx-full':
    ensure  => $version,
    notify  => Class['nginx::restart'],
    require => Package['nginx-common'],
  }
}

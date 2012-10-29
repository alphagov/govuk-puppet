class nginx::package {

  include apt

  apt::repository { 'nginx':
    type  => 'ppa',
    owner => 'nginx',
    repo  => 'stable',
  }

  case $::lsbdistcodename {
    'precise': {
      $version = '1.2.4-0ubuntu0ppa2~precise'
    }
    default: {
      $version = '1.2.4-0ubuntu0ppa2~lucid'
    }
  }

  package { 'nginx':
    ensure => $version,
    notify => Class['nginx::restart'],
  }

}

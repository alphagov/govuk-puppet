class nginx::package {

  apt::repository { 'nginx':
    type  => 'ppa',
    owner => 'nginx',
    repo  => 'stable',
  }

  case $::lsbdistcodename {
    'precise': {
      $version = '1.2.1-1ubuntu0ppa1~precise'
    }
    default: {
      $version = '1.2.1-1ubuntu0ppa2~lucid'
    }
  }

  package { 'nginx':
    ensure  => $version,
    notify  => Exec['nginx_restart'],
  }

}

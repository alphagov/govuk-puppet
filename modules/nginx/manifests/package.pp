class nginx::package {

  apt::repository { 'nginx':
    type  => 'ppa',
    owner => 'nginx',
    repo  => 'stable',
  }

  package { 'nginx':
    ensure  => '1.2.1-1ubuntu0ppa2~lucid',
    notify  => Exec['nginx_restart'],
  }

}

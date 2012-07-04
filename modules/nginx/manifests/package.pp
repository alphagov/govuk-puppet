class nginx::package {
  include apt

  apt::ppa_repository { 'nginx_ppa':
    publisher => 'nginx',
    repo      => 'stable',
  }
  package { 'nginx':
    ensure  => '1.2.1-1ubuntu0ppa2~lucid',
    require => [Apt::Ppa_Repository['nginx_ppa']],
    notify  => Exec['nginx_restart'],
  }
}

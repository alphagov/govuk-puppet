class nginx::package {
  include apt
  apt::ppa_repository { 'nginx_ppa':
    publisher => 'nginx',
    repo      => 'stable',
  }
  package { 'nginx-common':
    ensure  => '1.2.1-0*',
    require => Apt::Ppa_Repository['nginx_ppa'],
    notify  => Exec['nginx_restart'],
  }
  package { 'nginx-full':
    ensure  => '1.2.1-0*',
    require => [Apt::Ppa_Repository['nginx_ppa'],Package['nginx-common']],
    notify  => Exec['nginx_restart'],
  }
  package { 'nginx':
    ensure  => '1.2.1-0*',
    require => [Apt::Ppa_Repository['nginx_ppa'],Package['nginx-full']],
    notify  => Exec['nginx_restart'],
  }
}

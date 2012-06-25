class redis {
  apt::ppa_repository { 'redis-server':
    publisher => 'chris-lea',
    repo      => 'redis-server',
  }

  package { 'redis-server':
    ensure       => installed,
    name         => $::distribution_debian,
    require      => Apt::Ppa_Repository['redis-server'],
  }

  service { 'redis-server':
    ensure     => running,
    require    => Package['redis-server'],
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }
}

class nginx::fcgi {

  include govuk::ppa

  package { 'spawn-fcgi':
    ensure => present,
    notify => Class['nginx::service'],
  }

  package { 'fcgiwrap':
    ensure => present,
    notify => [Service['fcgiwrap'], Class['nginx::service']],
  }

  service { 'fcgiwrap':
    ensure => running,
    notify => Class['nginx::service'],
  }

  nginx::conf {'fastcgi':
    content => 'upstream fcgiwrap { server unix:/var/run/fcgiwrap.socket; }',
  }

}

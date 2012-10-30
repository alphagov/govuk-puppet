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

  file { '/etc/nginx/conf.d/fastcgi.conf':
    ensure  => present,
    content => 'upstream fcgiwrap { server unix:/var/run/fcgiwrap.socket; }',
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }

}

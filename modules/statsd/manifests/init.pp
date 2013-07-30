# == Class: statsd
#
# This class installs and sets-up statsd
#
class statsd {
  include nodejs

  package { 'statsd':
    ensure  => '0.4.0',
    require => Package['nodejs'],
  }

  file { '/etc/statsd.conf':
    source => 'puppet:///modules/graphite/etc/statsd.conf'
  }

  file { '/etc/init/statsd.conf':
    source  => 'puppet:///modules/graphite/etc/init/statsd.conf',
    require => [Package['statsd'], File['/etc/statsd.conf']],
  }

  service { 'statsd':
    ensure    => running,
    subscribe => [File['/etc/init/statsd.conf'], File['/etc/statsd.conf']],
  }
}

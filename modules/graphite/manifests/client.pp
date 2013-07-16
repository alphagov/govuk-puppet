# == Class: graphite::client
#
# This class installs and sets-up statsd
#
class graphite::client {

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

  file { '/etc/statsd/':
    ensure => directory,
  }

  file { '/etc/statsd/scripts':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
  }

  service { 'statsd':
    ensure    => running,
    subscribe => [File['/etc/init/statsd.conf'], File['/etc/statsd.conf']],
  }

  Graphite::Cronjob <| |>
}

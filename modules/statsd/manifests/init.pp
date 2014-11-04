# == Class: statsd
#
# This class installs and sets-up statsd
#
class statsd(
  $graphite_hostname
) {
  include govuk::ppa
  include nodejs

  package { 'statsd':
    ensure  => 'latest',
    require => Class['nodejs'],
  }

  file { '/etc/statsd.conf':
    content => template('statsd/etc/statsd.conf.erb'),
    require => Package['statsd'],
    notify  => Service['statsd'],
  }

  service { 'statsd':
    ensure  => running,
    require => [Package['statsd'], File['/etc/statsd.conf']],
  }
}

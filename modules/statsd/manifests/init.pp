# == Class: statsd
#
# This class installs and sets-up statsd
#
class statsd(
  $graphite_hostname
) {
  include govuk::ppa
  include nodejs

  # FIXME remove once statsd is updated everywhere.
  #
  # This is necessary to allow the package to install it's version.
  # puppet calls apt with the --force-confold option which means that this
  # would not otherwise be overwritten.
  exec {'stop statsd running under old upstart script':
    command => 'service statsd stop || /bin/true',
    onlyif  => 'grep -q "Web ops team" /etc/init/statsd.conf',
    before  => Exec['rm -f /etc/init/statsd.conf'],
  }
  exec {'rm -f /etc/init/statsd.conf':
    onlyif => 'grep -q "Web ops team" /etc/init/statsd.conf',
    before => Package['statsd'],
    notify => Service['statsd'],
  }

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

# == Class: mtail
#
# This class installs and sets-up Mtail
#
# === Parameters
#
# [*logs*]
#   List of files to monitor
#
# [*enabled*]
#   Enable Mtail service. (default false)
#
# [*port*]
#   HTTP port to listen on. (default "3903")
#
# [*collectd_socketpath*]
#   Path to collectd unixsock to write metrics to.
#
# [*graphite_host_port*]
#   Host:port to graphite carbon server to write metrics to.
#
# [*statsd_hostport*]
#   Host:port to statsd server to write metrics to.
#
# [*metric_push_interval*]
#   Interval between metric pushes, in seconds (default 60)
#
# [*extra_args*]
#   Mtail program extra arguments (default -log_dir /var/log/mtail)
#
class mtail(
  $logs,
  $enabled = false,
  $port = 3903,
  $collectd_socketpath = undef,
  $graphite_host_port = undef,
  $statsd_hostport = undef,
  $metric_push_interval = 60,
  $extra_args = '-log_dir /var/log/mtail',
) {

  validate_bool($enabled)

  package { 'mtail':
#    ensure  => 'latest',
    ensure => 'absent',
  }

  file { '/etc/default/mtail':
    ensure  => 'absent',
    content => template('mtail/default_mtail'),
#    require => Package['mtail'],
#    notify  => Service['mtail'],
  }

  file { '/etc/mtail':
#    ensure  => directory,
    ensure => 'absent',
    mode   => '0755',
    force  => true,
#    require => Package['mtail'],
  }

  file { '/etc/init.d/mtail':
#    ensure  => present,
    ensure => 'absent',
    mode   => '0755',
    source => 'puppet:///modules/mtail/init',
#    require => Package['mtail'],
  }

#  service { 'mtail':
#    ensure  => running,
#    ensure => stopped,
#    require => [Package['mtail'], File['/etc/init.d/mtail']],
#  }
}

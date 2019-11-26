# == Class: statsd
#
# This class installs and sets-up statsd
#
# === Parameters
#
# [*graphite_hostname*]
#   Graphite hostname
#
class statsd(
  $graphite_hostname,
) {

  include nodejs
  include statsd::repo

  package { 'statsd':
    ensure  => 'latest',
    require => Class['nodejs'],
  }

  file { '/etc/statsd/config.js':
    content => template('statsd/etc/statsd.conf.erb'),
    require => Package['statsd'],
    notify  => Service['statsd'],
  }

  service { 'statsd':
    ensure  => running,
    require => [Package['statsd'], File['/etc/statsd/config.js']],
  }

  @@icinga::check { "check_statsd_upstart_up_${::hostname}":
    check_command       => 'check_nrpe!check_upstart_status!statsd',
    service_description => 'statsd upstart up',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }
}

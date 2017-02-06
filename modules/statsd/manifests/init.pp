# == Class: statsd
#
# This class installs and sets-up statsd
#
# === Parameters
#
# [*graphite_hostname*]
#   Graphite hostname
#
# [*manage_repo_class*]
#   Whether to use a separate repository to install Statsd
#   Default: false (use 'govuk_ppa' repository)
#
class statsd(
  $graphite_hostname,
  $manage_repo_class = false,
) {

  validate_bool($manage_repo_class)

  include nodejs

  if $manage_repo_class {
    include statsd::repo
  } else {
    include govuk_ppa
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

  @@icinga::check { "check_statsd_upstart_up_${::hostname}":
    check_command       => 'check_nrpe!check_upstart_status!statsd',
    service_description => 'statsd upstart up',
    host_name           => $::fqdn,
  }
}

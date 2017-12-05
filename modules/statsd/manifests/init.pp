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
  $use_smart_repeater = false,
  $graphite_hostname = undef,
  $smart_repeater_hostname = undef,
  $manage_repo_class = false,
) {

  validate_bool($manage_repo_class)

  include nodejs

  if $manage_repo_class {
    include statsd::repo
  } else {
    include govuk_ppa
  }

  if ($use_smart_repeater) and ($smart_repeater_hostname == undef) {
    fail 'A $smart_repeater_hostname is required'
  }

  # commented out while graphite hostname is required
  # if (!$use_smart_repeater) and ($graphite_hostname == undef) {
  #   fail 'A $graphite_hostname is required'
  # }

  file { '/usr/share/statsd/backends/smart_repeater.js':
    ensure => present,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/statsd/smart_repeater.js',
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

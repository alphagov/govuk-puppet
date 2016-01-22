# == Class: govuk_gor
#
# Setup gor traffic replay for GOV.UK
#
# === Parameters
#
# [*args*]
#   Command-line arguments to pass to Gor executable, defaults to an empty hash
#
# [*enable*]
#   Whether to enable the Gor service and its related checks and dependencies; defaults to false
#
# [*version*]
#   Which version of the Go package to install; defaults to latest
#
class govuk_gor(
  $args = {},
  $enable = false,
  $version = 'latest',
) {
  include govuk_ppa

  validate_bool($enable)

  file { '/etc/govuk/env.d/FACTER_data_sync_in_progress':
    ensure  => present,
    owner   => 'deploy',
    require => Class['govuk::deploy'],
  }

  if $enable and ! $::data_sync_in_progress {
    $gor_service_ensure = running
    $nagios_ensure      = present
    $logstream_ensure   = present
  } else {
    $gor_service_ensure = stopped
    $nagios_ensure      = absent
    $logstream_ensure   = absent
  }

  class { '::gor':
    args           => $args,
    package_ensure => $version,
    service_ensure => $gor_service_ensure,
  } ->
  govuk_logging::logstream { 'gor_upstart_log':
    ensure  => $logstream_ensure,
    fields  => {'application' => 'gor'},
    logfile => '/var/log/upstart/gor.log',
    tags    => ['stdout', 'stderr', 'upstart', 'gor'],
  }

  @@icinga::check { "check_gor_running_${::hostname}":
    ensure              => $nagios_ensure,
    check_command       => 'check_nrpe!check_proc_running!gor',
    host_name           => $::fqdn,
    service_description => 'gor running',
  }
}

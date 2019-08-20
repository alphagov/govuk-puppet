# == Class: govuk_gor
#
# Setup gor traffic replay for GOV.UK
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname of the APT mirror to install Gor from
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
# [*binary_path*]
#   Explicitly set the location of the Gor binary.
#
# [*envvars*]
#   Set any environment variables that will be loaded into the Gor service.
#
class govuk_gor(
  $args = {},
  $enable = false,
  $version = '0.16.1',
  $binary_path = '/usr/local/bin/goreplay',
  $envvars = {},
  $apt_mirror_hostname,
) {

  apt::source { 'gor':
    location     => "http://${apt_mirror_hostname}/gor",
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
    architecture => $::architecture,
  }

  include govuk_ppa

  validate_bool($enable)

  $data_sync_fact_path = '/etc/govuk/env.d/FACTER_data_sync_in_progress'

  file { $data_sync_fact_path:
    ensure  => present,
    owner   => 'deploy',
    require => Class['govuk::deploy'],
  }

  cron { 'stop_gor':
    command => "echo 'true' > ${data_sync_fact_path}; sudo initctl stop gor",
    user    => 'deploy',
    hour    => 22,
    minute  => 0,
  }

  cron { 'start_gor':
    command => "echo '' > ${$data_sync_fact_path}; sudo initctl start gor;",
    user    => 'deploy',
    hour    => 5,
    minute  => 45,
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

  # This is to remove the old gor 0.14.1
  package { 'gor':
    ensure => absent,
  }

  class { '::gor':
    args           => $args,
    package_name   => 'goreplay',
    package_ensure => $version,
    service_ensure => $gor_service_ensure,
    envvars        => $envvars,
    binary_path    => $binary_path,
  }

  @filebeat::prospector { 'gor_upstart_log':
    ensure => $logstream_ensure,
    fields => {'application' => 'gor'},
    paths  => ['/var/log/upstart/gor.log'],
    tags   => ['stdout', 'stderr', 'upstart', 'gor'],
  }

  @@icinga::check { "check_gor_running_${::hostname}":
    ensure              => $nagios_ensure,
    check_command       => 'check_nrpe!check_proc_running!goreplay',
    host_name           => $::fqdn,
    service_description => 'gor running',
    notes_url           => monitoring_docs_url(gor),
  }
}

# == Class: clamav::service
#
# Set up service resources and monitoring for ClamAV.
#
# === Parameters
#
# [*use_service*]
#   Boolean indicating whether ClamAV should be set up
#   with service resources and service monitoring.
#
# [*puppet_lifecycle_enable*]
#   Boolean indicating whether ClamAV lifecycle: start, stop,
#   restart is managed via puppet. Some instances do not need
#   clamav to be running all the time.
#   Default: true
#
class clamav::service (
    $use_service,
    $puppet_lifecycle_enable = true
  ) {

  if $puppet_lifecycle_enable {
    service { ['clamav-freshclam', 'clamav-daemon']:
      ensure => $use_service,
      enable => $use_service,
    }
  }

  if $use_service {
    @@icinga::check { "check_clamd_running_${::hostname}":
      check_command       => 'check_nrpe!check_proc_running!clamd',
      service_description => 'clamd not running',
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(check-process-running),
    }
  }
}

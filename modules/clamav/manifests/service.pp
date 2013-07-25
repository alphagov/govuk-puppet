class clamav::service {
  $enable_service = $::govuk_platform ? {
    'development' => stopped,
    default       => running,
  }

  service { ['clamav-freshclam', 'clamav-daemon']:
    ensure  => $enable_service,
  }

  if $enable_service == 'running' {
    @@nagios::check { "check_clamd_running_${::hostname}":
      check_command       => 'check_nrpe!check_proc_running!clamd',
      service_description => 'clamd not running',
      host_name           => $::fqdn,
    }
  }
}

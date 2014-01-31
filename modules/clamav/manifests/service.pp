class clamav::service {
  $enable_service = $::govuk_platform ? {
    'development' => false,
    default       => true,
  }

  service { ['clamav-freshclam', 'clamav-daemon']:
    ensure  => $enable_service,
    enable  => $enable_service,
  }

  if $enable_service {
    @@icinga::check { "check_clamd_running_${::hostname}":
      check_command       => 'check_nrpe!check_proc_running!clamd',
      service_description => 'clamd not running',
      host_name           => $::fqdn,
    }
  }
}

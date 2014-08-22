# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class clamav::service (
    $use_service
  ) {

  service { ['clamav-freshclam', 'clamav-daemon']:
    ensure => $use_service,
    enable => $use_service,
  }

  if $use_service {
    @@icinga::check { "check_clamd_running_${::hostname}":
      check_command       => 'check_nrpe!check_proc_running!clamd',
      service_description => 'clamd not running',
      host_name           => $::fqdn,
    }
  }
}

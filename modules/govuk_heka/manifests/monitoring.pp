# == Class: govuk_heka::monitoring
#
# Monitoring for Heka.
#
class govuk_heka::monitoring {
  @@icinga::check { "check_heka_running_${::hostname}":
    check_command       => 'check_nrpe!check_upstart_status!heka',
    service_description => 'heka running',
    host_name           => $::fqdn,
  }
}

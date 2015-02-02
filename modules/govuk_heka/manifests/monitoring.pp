# == Class: govuk_heka::monitoring
#
# Monitoring for Heka.
#
# === Parameters
#
# [*tcp_port*]
#   Port that Heka's TCP Input/Output plugin listens on
#   Mandatory
#
class govuk_heka::monitoring (
  $tcp_port,
){
  @@icinga::check { "check_heka_running_${::hostname}":
    check_command       => 'check_nrpe!check_upstart_status!heka',
    service_description => 'heka running',
    host_name           => $::fqdn,
  }

  collectd::plugin::tcpconn { 'heka':
    incoming => $tcp_port,
    outgoing => $tcp_port,
  }
}

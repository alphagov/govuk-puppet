# == Define: icinga::client::check_ping
#
# Create an Icinga monitoring which will monitor an IP address from a given.
#
# ===Parameters:
#
# [*ip*]
#   The IP address of the host to ping.
#
define icinga::client::check_ping (
  $ip,
) {

  @@icinga::check { "check_ping_from_${::hostname}_to_${title}":
    check_command       => "check_nrpe!check_ping!${ip}",
    service_description => 'cannot ping',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(defined-cannot-ping),
  }

}

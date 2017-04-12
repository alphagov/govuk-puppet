# == Define: monitoring::network_checks
#
# Create a host with specified IP address and name, and include a basic ping
# check.
#
# ===Parameters:
#
# [*address*]
#   The IP address of the host.
#
define monitoring::network_checks (
  $address,
) {
    icinga::host { $title:
      host_name           => $title,
      hostalias           => $title,
      address             => $address,
      display_name        => $title,
      notification_period => 'inoffice',
      use                 => 'third-party-host',
    }

    icinga::check { "check_ping_${title}":
      check_command       => 'check_ping!100.0,20%!500.0,60%',
      notification_period => '24x7',
      use                 => 'govuk_high_priority',
      service_description => 'unable to ping',
      host_name           => $title,
      notes_url           => monitoring_docs_url(vpn-down),
    }
}

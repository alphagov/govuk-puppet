# == Class: govuk_ghe_vpn
#
# Configure the VPN connection to GitHub Enterprise (GHE)
#
# === Parameters
#
# Document parameters here.
#
# [*url*]
#   VPN endpoint to connect to
#
# [*username*]
#   VPN username
#
# [*password*]
#   VPN password
#
class govuk_ghe_vpn (
  $url,
  $username,
  $password,
) {

  host { 'github.gds':
    ip      => '192.168.9.110',
    comment => 'Ignore VPN DNS and set static host for GHE',
  }

  class { '::openconnect':
    url       => $url,
    user      => $username,
    pass      => $password,
    dnsupdate => false,
  }

  @@icinga::check { "check_openconnect_upstart_up_${::hostname}":
    check_command       => 'check_nrpe!check_upstart_status!openconnect',
    service_description => 'openconnect upstart up',
    host_name           => $::fqdn,
  }

  @icinga::nrpe_config { 'check_ghe_responding':
    source => 'puppet:///modules/govuk_ghe_vpn/nrpe_check_ghe.cfg',
  }

  @@icinga::check { "check_ghe_connection_on_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_ghe_responding',
    service_description => 'Connection to GitHub Enterprise over HTTPS',
    host_name           => $::fqdn,
  }
}

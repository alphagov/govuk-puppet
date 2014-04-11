class govuk::ghe_vpn {

  host { 'github.gds':
    ip      => '192.168.9.110',
    comment => 'Ignore VPN DNS and set static host for GHE',
  }

  # Other params come from hiera.
  class { '::openconnect':
    dnsupdate => false,
  }

  @@icinga::check { "check_openconnect_upstart_up_${::hostname}":
    check_command       => 'check_nrpe!check_upstart_status!openconnect',
    service_description => 'openconnect upstart up',
    host_name           => $::fqdn,
  }
}

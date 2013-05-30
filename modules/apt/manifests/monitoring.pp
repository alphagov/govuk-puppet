class apt::monitoring {
  @nagios::nrpe_config { 'check_apt_updates':
    source => 'puppet:///modules/apt/etc/nagios/nrpe.d/check_apt_updates.cfg',
  }
  @nagios::plugin { 'check_apt_updates':
    source => 'puppet:///modules/apt/usr/lib/nagios/plugins/check_apt_updates',
  }
  @@nagios::check { "check_apt_updates_${::hostname}":
    check_command       => 'check_nrpe!check_apt_updates!200 1000',
    service_description => "outstanding package updates",
    host_name           => $::fqdn,
  }
}

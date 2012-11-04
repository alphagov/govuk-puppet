class nagios::client::check_apt_updates {
  @nagios::plugin { 'check_apt_updates':
    source  => 'puppet:///modules/nagios/usr/lib/nagios/plugins/check_apt_updates',
  }
  @@nagios::check { "check_apt_updates_${::hostname}":
    check_command       => 'check_nrpe!check_apt_updates!100 100',
    service_description => "outstanding package updates",
    host_name           => $::fqdn,
  }
}

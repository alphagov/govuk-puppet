class nagios::client::check_rw_rootfs {
  @nagios::plugin { 'check_apt_updates':
    source  => 'puppet:///modules/nagios/usr/lib/nagios/plugins/check_apt_updates',
  }
  @@nagios::check { "check_apt_updates_${::hostname}":
    check_command           => 'check_nrpe_1arg!check_apt_updates',
    service_description => "check package updates on ${::govuk_class}-${::hostname}",
    host_name       => "${::govuk_class}-${::hostname}",
  }
}

# == Class: clamav::monitoring
#
# Nagios check to ensure that the daily definitions have been updated by the
# hourly crontab. As the name suggests, these should update at least every
# day. There are other definition files but this is a good canary.
#
class clamav::monitoring {
  @@nagios::check { "check_clamav_definitions_${::hostname}":
    check_command       => 'check_nrpe!check_path_age!/opt/clamav/share/clamav/daily.cvd 2',
    service_description => "clamav definitions out of date",
    host_name           => $::fqdn,
    require             => Class['nagios::client::check_path_age'],
  }
}

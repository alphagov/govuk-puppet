# == Class: clamav::monitoring
#
# Nagios check to ensure that the daily definitions have been updated by the
# hourly crontab. As the name suggests, these should update at least every
# day. There are other definition files but this is a good canary.
#
class clamav::monitoring {
  # Convert days to seconds.
  $warning_age = 2 * (24 * 60 * 60)

  @@icinga::check { "check_clamav_definitions_${::hostname}":
    check_command       => "check_nrpe!check_file_age!\"-f /var/lib/clamav/daily.cld -c0 -w${warning_age}\"",
    service_description => 'clamav definitions out of date',
    host_name           => $::fqdn,
  }
}

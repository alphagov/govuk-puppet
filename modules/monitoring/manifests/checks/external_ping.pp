# == Define: monitoring::checks::external_ping
#
# Create an Icinga check to ping an external host, i.e. a host
# for which we have no `Icinga::Host` resource defined.
#
# Wraps `Icinga::Host`.
#
# === Parameters
#
# [*host*]
#   The IP address or hostname of the host to ping.
#
# [*ensure*]
#   Can be used to remove an existing check.
#   Default: present
#
# [*notification_period*]
#   The title of a `Icinga::Timeperiod` resource.
#   Default: inoffice
#
# [*use*]
#   The title of a `Icinga::Service_template` resource which this service
#   should inherit.
#   Default: govuk_regular_service
#
# [*notes_url*]
#   Documentation URL for more information about how to diagnose the service
#   and why the alert might exist. Should link to a section of the
#   "opsmanual". This will be included in the Nagios UI and email alerts.
#
# [*contact_groups*]
#   Convenience method to use in addition to the service
#   templates. This is so you can pass a group to a check without
#   having to define a new service template
#
# [*warning_threshold*]
#   Comma-delimited pair of values determining the average round trip time in
#   milliseconds and the percentage of packet loss as a threshold at which we
#   should raise a warning alert.
#
#   See the check_ping docs for more info:
#   https://www.monitoring-plugins.org/doc/man/check_ping.html
#
# [*critical_threshold*]
#   Comma-delimited pair of values determining the average round trip time in
#   milliseconds and the percentage of packet loss as a threshold at which we
#   should raise a critical alert.
#
#   See the check_ping docs for more info:
#   https://www.monitoring-plugins.org/doc/man/check_ping.html
#
define monitoring::checks::external_ping(
  $host,
  $ensure              = 'present',
  $notification_period = 'inoffice',
  $use                 = 'govuk_high_priority',
  $notes_url           = undef,
  $contact_groups      = undef,
  $warning_threshold   = '10.0,20%',
  $critical_threshold  = '50.0,60%',
) {

  if ! defined(Icinga::Check_config['check_ping_external']) {
    icinga::check_config { 'check_ping_external':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_ping_external.cfg',
    }
  }

  icinga::check { "check_external_ping_${title}":
    host_name           => $::fqdn,
    service_description => "Unable to ping ${title} at ${host}",
    notification_period => $notification_period,
    use                 => $use,
    notes_url           => $notes_url,
    check_command       => "check_ping_external!${host}!${warning_threshold}!${critical_threshold}",
  }

}

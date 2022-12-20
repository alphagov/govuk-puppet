# == Class: monitoring::pagerduty_drill
#
# Set up a weekly check that PagerDuty is working.
#
# The cron resource creates the `pagerduty_drill` file.
# The file existing triggers the Icinga alert
# which notifies PagerDuty and calls the on-call phone.
#
# === Parameters
#
# [*enabled*]
#   Should the PagerDuty drill be enabled?
#
class monitoring::pagerduty_drill (
  $enabled = false,
) {
  if $enabled {
    $filename = '/var/run/pagerduty_drill'

    file { '/usr/local/bin/govuk_pagerduty_drill_start':
      content => template('monitoring/govuk_pagerduty_drill_start.erb'),
      mode    => '0755',
    }

    cron { 'pagerduty_drill_start':
      ensure  => present,
      user    => 'root',
      weekday => absent,
      hour    => [10, 18],
      minute  => 0,
      command => '/usr/local/bin/govuk_pagerduty_drill_start',
    }

    cron { 'pagerduty_drill_stop':
      ensure  => present,
      user    => 'root',
      weekday => absent,
      hour    => [10, 18],
      minute  => 15,
      command => "rm -f ${filename}",
    }

    @@icinga::check { "pagerduty_drill_on_${::hostname}":
      check_command              => "check_nrpe!check_file_not_exists!${filename}",
      use                        => 'govuk_urgent_priority',
      service_description        => 'PagerDuty test drill. Developers: escalate this alert. SMT: resolve this alert.',
      host_name                  => $::fqdn,
      notes_url                  => monitoring_docs_url(pagerduty),
      attempts_before_hard_state => 1,
    }
  }
}

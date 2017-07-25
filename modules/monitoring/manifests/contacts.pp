# == Class: monitoring::contacts
#
# Setup contacts and assign them to priorities for Icinga alerts.
#
# === Parameters
#
# [*pagerduty_servicekey*]
#   PagerDuty API key.
#   Default: ''
#
# [*notify_pager*]
#   Whether to alert PagerDuty.
#   Default: false
#
# [*notify_slack*]
#   Whether to alert Slack.
#   Default: false
#
# [*slack_subdomain*]
#   Slack subdomain to send alerts to.
#   Default: undef
#
# [*slack_channel*]
#   Slack channel to send alerts to.
#   Default: undef
#
# [*slack_username*]
#   Slack username to send alerts with.
#   Default: undef
#
# [*slack_token*]
#   Slack token to send alerts with.
#   Default: undef
#
# [*slack_alert_url*]
#   URL to include in Slack alerts.
#   Default: 'https://example.com/cgi-bin/icinga/status.cgi'
#
class monitoring::contacts (
  $pagerduty_servicekey = '',
  $notify_pager = false,
  $notify_slack = false,
  $notify_graphite = false,
  $slack_subdomain = undef,
  $slack_channel = undef,
  $slack_username = 'Icinga',
  $slack_token = undef,
  $slack_alert_url = 'https://example.com/cgi-bin/icinga/status.cgi',
) {
  validate_bool($notify_pager, $notify_slack, $notify_graphite)

  $midnight_day_start = '00:00'
  $office_day_start = '09:30'
  $midday = '12:00'
  $office_day_end = '17:30'
  $midnight_day_end = '24:00'

  $all_day = "${midnight_day_start}-${midnight_day_end}"
  $office_day = "${office_day_start}-${office_day_end}"
  $office_day_morning = "${office_day_start}-${midday}"
  $office_day_afternoon = "${midday}-${office_day_end}"
  $oncall_early_day = "${midnight_day_start}-${office_day_start}"
  $oncall_late_day = "${office_day_end}-${midnight_day_end}"

  icinga::timeperiod { '24x7':
    timeperiod_alias => '24 Hours A Day, 7 Days A Week',
    sun              => $all_day,
    mon              => $all_day,
    tue              => $all_day,
    wed              => $all_day,
    thu              => $all_day,
    fri              => $all_day,
    sat              => $all_day,
  }

  icinga::timeperiod { 'inoffice':
    timeperiod_alias => '2nd line in-office hours',
    mon              => $office_day,
    tue              => $office_day,
    wed              => $office_day,
    thu              => $office_day,
    fri              => $office_day,
  }

  icinga::timeperiod { 'inoffice_afternoon':
    timeperiod_alias => '2nd line in-office hours, afternoon',
    mon              => $office_day_afternoon,
    tue              => $office_day_afternoon,
    wed              => $office_day_afternoon,
    thu              => $office_day_afternoon,
    fri              => $office_day_afternoon,
  }

  icinga::timeperiod { 'oncall':
    timeperiod_alias => '2nd line out of hours',
    sun              => $all_day,
    mon              => "${oncall_early_day},${oncall_late_day}",
    tue              => "${oncall_early_day},${oncall_late_day}",
    wed              => "${oncall_early_day},${oncall_late_day}",
    thu              => "${oncall_early_day},${oncall_late_day}",
    fri              => "${oncall_early_day},${oncall_late_day}",
    sat              => $all_day,
  }

  icinga::timeperiod { 'never':
    timeperiod_alias => 'Never',
  }

  if $notify_slack and ($slack_subdomain and $slack_token and $slack_channel) {
    icinga::slack_contact { 'slack_notification':
      slack_token     => $slack_token,
      slack_channel   => $slack_channel,
      slack_subdomain => $slack_subdomain,
      slack_username  => $slack_username,
      nagios_cgi_url  => $slack_alert_url,
    }

    $slack_members = ['slack_notification']
  } else {
    $slack_members = []
  }

  if $notify_graphite {
    icinga::graphite_contact { 'graphite_notification': }
    $graphite_members = ['graphite_notification']
  } else {
    $graphite_members = []
  }

  if ($pagerduty_servicekey != '') {
    icinga::pagerduty_contact { '24x7':
      notify_when          => ['critical'],
      notification_period  => '24x7',
      pagerduty_servicekey => $pagerduty_servicekey,
    }
  }

  # Urgent
  $pager_members = $notify_pager ? {
    true    => ['pagerduty_24x7'],
    default => [],
  }
  icinga::contact_group { 'urgent-priority':
    group_alias => 'Contacts for urgent priority alerts',
    members     => flatten([
      $graphite_members,
      $slack_members,
      $pager_members,
    ]),
  }
  icinga::service_template { 'govuk_urgent_priority':
    contact_groups => ['urgent-priority'],
  }

  # High
  icinga::contact_group { 'high-priority':
    group_alias => 'Contacts for high priority alerts',
    members     => flatten([
      $graphite_members,
      $slack_members,
    ]),
  }
  icinga::service_template { 'govuk_high_priority':
    contact_groups => ['high-priority'],
  }

  # Normal
  icinga::contact_group { 'normal-priority':
    group_alias => 'Contacts for normal priority alerts',
    members     => flatten([
      $graphite_members,
      $slack_members,
    ]),
  }
  icinga::service_template { 'govuk_normal_priority':
    contact_groups => ['normal-priority'],
  }

  # Regular
  icinga::contact_group { 'regular':
    group_alias => 'Contacts for regular alerts',
    members     => flatten([
      $graphite_members,
      $slack_members,
    ]),
  }
  icinga::service_template { [
    'govuk_regular_service',
    'govuk_low_priority',
  ]:
    contact_groups => ['regular'],
  }
}

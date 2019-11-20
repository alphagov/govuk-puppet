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
# [*slack_channel*]
#   Slack channel to send alerts to.
#   Default: undef
#
# [*slack_username*]
#   Slack username to send alerts with.
#   Default: undef
#
# [*slack_webhook_url*]
#   Slack Webhook URL to send alerts with.
#   Default: undef
#
# [*slack_icinga_status_cgi_url*]
#   URL to use in Slack messages when linking to Icinga.
#   Default: 'https://example.com/cgi-bin/icinga/status.cgi'
#
# [*slack_icinga_extinfo_cgi_url*]
#   URL to use in Slack messages when linking to Icinga.
#   Default: 'https://example.com/cgi-bin/icinga/status.cgi'
#
class monitoring::contacts (
  $pagerduty_servicekey = '',
  $notify_pager = false,
  $notify_slack = false,
  $notify_graphite = true,
  $slack_channel = undef,
  $slack_username = 'Icinga',
  $slack_webhook_url = undef,
  $slack_icinga_status_cgi_url = 'https://example.com/cgi-bin/icinga/status.cgi',
  $slack_icinga_extinfo_cgi_url = 'https://example.com/cgi-bin/icinga/extinfo.cgi',
) {
  validate_bool($notify_pager, $notify_slack, $notify_graphite)

  $midnight_day_start = '00:00'
  $office_day_start = '09:30'
  $midday = '12:00'
  $office_day_end = '17:30'
  $midnight_day_end = '24:00'
  # This should match up with the govuk_data_sync_in_progress class
  $data_sync_start = '22:00'
  $data_sync_end = '05:45'

  $all_day = "${midnight_day_start}-${midnight_day_end}"
  $office_day = "${office_day_start}-${office_day_end}"
  $office_day_morning = "${office_day_start}-${midday}"
  $office_day_afternoon = "${midday}-${office_day_end}"
  $oncall_early_day = "${midnight_day_start}-${office_day_start}"
  $oncall_late_day = "${office_day_end}-${midnight_day_end}"
  $not_data_sync = "${data_sync_end}-${data_sync_start}"

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

  icinga::timeperiod { 'not_data_sync':
    timeperiod_alias => 'Not when data syncs could be taking place',
    sun              => $not_data_sync,
    mon              => $not_data_sync,
    tue              => $not_data_sync,
    wed              => $not_data_sync,
    thu              => $not_data_sync,
    fri              => $not_data_sync,
    sat              => $not_data_sync,
  }

  icinga::timeperiod { 'never':
    timeperiod_alias => 'Never',
  }

  if $notify_slack and ($slack_webhook_url and $slack_channel) {
    icinga::slack_contact { 'slack_notification':
      slack_webhook_url      => $slack_webhook_url,
      slack_channel          => $slack_channel,
      slack_username         => $slack_username,
      icinga_status_cgi_url  => $slack_icinga_status_cgi_url,
      icinga_extinfo_cgi_url => $slack_icinga_extinfo_cgi_url,
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

  # Data Informed Content
  if $slack_webhook_url {
    icinga::slack_contact { 'slack_data_informed':
      slack_webhook_url      => $slack_webhook_url,
      slack_channel          => '#govuk-data-inf-alerts',
      slack_username         => $slack_username,
      icinga_status_cgi_url  => $slack_icinga_status_cgi_url,
      icinga_extinfo_cgi_url => $slack_icinga_extinfo_cgi_url,
    }

    icinga::contact_group { 'slack-channel-data-informed':
      group_alias => 'Contact #govuk-data-informed',
      members     => ['slack_data_informed'],
    }
  }

  # Search Team
  if $slack_webhook_url {
    icinga::slack_contact { 'slack_search_team':
      slack_webhook_url      => $slack_webhook_url,
      slack_channel          => '#govuk-searchandnav',
      slack_username         => $slack_username,
      icinga_status_cgi_url  => $slack_icinga_status_cgi_url,
      icinga_extinfo_cgi_url => $slack_icinga_extinfo_cgi_url,
    }

    icinga::contact_group { 'slack-channel-search-team':
      group_alias => 'Contact #govuk-searchandnav',
      members     => ['slack_search_team'],
    }
  }
}

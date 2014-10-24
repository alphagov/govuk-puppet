# == Class: monitoring::contacts
#
# Setup contacts and assign them to priorities for Icinga alerts.
#
# === Parameters
#
# [*email*]
#   Email address to send all alerts to. Typically a Google Group.
#   Default: 'root@localhost'
#
# [*pagerduty_apikey*]
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
# [*slack_nagios_url*]
#   URL to include in Slack alerts.
#   Default: 'https://example.com/cgi-bin/icinga/status.cgi'
#
class monitoring::contacts (
  $email = 'root@localhost',
  $pagerduty_apikey = '',
  $notify_pager = false,
  $notify_slack = false,
  $slack_subdomain = undef,
  $slack_channel = undef,
  $slack_username = 'Icinga',
  $slack_token = undef,
  $slack_nagios_url = 'https://example.com/cgi-bin/icinga/status.cgi',
) {
  validate_bool($notify_pager, $notify_slack)

  icinga::timeperiod { '24x7':
    timeperiod_alias => '24 Hours A Day, 7 Days A Week',
    sun              => '00:00-24:00',
    mon              => '00:00-24:00',
    tue              => '00:00-24:00',
    wed              => '00:00-24:00',
    thu              => '00:00-24:00',
    fri              => '00:00-24:00',
    sat              => '00:00-24:00',
  }

  icinga::timeperiod { 'workhours':
    timeperiod_alias => 'Standard Work Hours',
    mon              => '09:00-17:00',
    tue              => '09:00-17:00',
    wed              => '09:00-17:00',
    thu              => '09:00-17:00',
    fri              => '09:00-17:00',
  }

  icinga::timeperiod { 'nonworkhours':
    timeperiod_alias => 'Non-Work Hours',
    sun              => '00:00-24:00',
    mon              => '00:00-09:00,16:00-24:00',
    tue              => '00:00-09:00,16:00-24:00',
    wed              => '00:00-09:00,16:00-24:00',
    thu              => '00:00-09:00,16:00-24:00',
    fri              => '00:00-09:00,17:00-24:00',
    sat              => '00:00-24:00',
  }

  icinga::timeperiod { 'never':
    timeperiod_alias => 'Never',
  }


  $google_members = 'monitoring_google_group'
  icinga::contact { $google_members:
    email => $email,
  }

  if $notify_slack and ($slack_subdomain and $slack_token and $slack_channel) {
    icinga::slack_contact { 'slack_notification':
      slack_token     => $slack_token,
      slack_channel   => $slack_channel,
      slack_subdomain => $slack_subdomain,
      slack_username  => $slack_username,
      nagios_cgi_url  => $slack_nagios_url,
    }

    $slack_members = ['slack_notification']
  } else {
    $slack_members = []
  }

  if ($pagerduty_apikey != '') {
    icinga::pager_contact { 'pager_nonworkhours':
      service_notification_options => 'c',
      notification_period          => '24x7',
      pagerduty_apikey             => $pagerduty_apikey,
    }
  }
  $pager_members = $notify_pager ? {
    true    => ['pager_nonworkhours'],
    default => [],
  }


  # Urgent
  icinga::contact_group { 'urgent-priority':
    group_alias => 'Contacts for urgent priority alerts',
    members     => flatten([
      $google_members,
      $slack_members,
      $pager_members,
    ])
  }
  icinga::service_template { 'govuk_urgent_priority':
    contact_groups => ['urgent-priority']
  }

  # High
  icinga::contact_group { 'high-priority':
    group_alias => 'Contacts for high priority alerts',
    members     => flatten([
      $google_members,
      $slack_members,
    ])
  }
  icinga::service_template { 'govuk_high_priority':
    contact_groups => ['high-priority']
  }

  # Normal
  icinga::contact_group { 'normal-priority':
    group_alias => 'Contacts for normal priority alerts',
    members     => flatten([
      $google_members,
      $slack_members,
    ])
  }
  icinga::service_template { 'govuk_normal_priority':
    contact_groups => ['normal-priority']
  }

  # Regular
  icinga::contact_group { 'regular':
    group_alias => 'Contacts for regular alerts',
    members     => flatten([
      $google_members,
      $slack_members,
    ])
  }
  icinga::service_template { [
    'govuk_regular_service',
    'govuk_low_priority',
    'govuk_unprio_priority',
  ]:
    contact_groups => ['regular']
  }
}

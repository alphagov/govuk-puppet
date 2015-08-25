# == Define: icinga::pagerduty_contact
#
# Creates a PagerDuty contact for Icinga to use
#
# === Parameters
#
# [*notify_when*]
#   Which Icinga states should cause this contact to be used
#
# [*notification_period*]
#   The `icinga::timeperiod` to use for this contact
#
# [*pagerduty_servicekey*]
#   The service key (not API key, they're different) to authenticate
#   with. See https://govuk.pagerduty.com/services/.
#
define icinga::pagerduty_contact (
  $notify_when = ['warning', 'unknown', 'critical', 'recoveries'],
  $notification_period = '24x7',
  $pagerduty_servicekey = '',
) {

  $service_notification_options = join(regsubst($notify_when, '^([a-z])[a-z]+$', '\1'), ',')

  file {"/etc/icinga/conf.d/contact_pagerduty_${name}.cfg":
    content => template('icinga/pagerduty_contact.cfg.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

}

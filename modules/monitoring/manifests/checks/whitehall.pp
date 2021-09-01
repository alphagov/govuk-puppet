# == Class: monitoring::checks::whitehall
#
# Icinga checks for Whitehall.
#
# === Parameters
#
# [*check_period*]
#   Icinga time period for the checks.
#
class monitoring::checks::whitehall ($check_period = undef) {
  $app_domain = hiera('app_domain')

  $whitehall_hostname = "whitehall-admin.${app_domain}"
  $whitehall_overdue_url = '/healthcheck/overdue'
  $whitehall_scheduled_url = '/healthcheck/unenqueued_scheduled_editions'

  icinga::check_config { 'whitehall_overdue':
    content => template('monitoring/check_whitehall_overdue.cfg.erb'),
    require => Icinga::Plugin['check_http_timeout_noncrit'],
  }

  icinga::check { 'check_whitehall_overdue':
    check_command              => 'check_whitehall_overdue',
    service_description        => 'overdue publications in Whitehall',
    use                        => 'govuk_urgent_priority',
    host_name                  => $::fqdn,
    notes_url                  => monitoring_docs_url(whitehall-scheduled-publishing),
    action_url                 => "https://${whitehall_hostname}${whitehall_overdue_url}",
    event_handler              => 'publish_overdue_whitehall',
    check_period               => $check_period,
    attempts_before_hard_state => 10,
    retry_interval             => 1,
  }

  icinga::check_config { 'whitehall_scheduled':
    content => template('monitoring/check_whitehall_scheduled.cfg.erb'),
    require => Icinga::Plugin['check_http_timeout_noncrit'],
  }

  icinga::check { 'check_whitehall_scheduled':
    check_command              => 'check_whitehall_scheduled',
    service_description        => 'scheduled publications in Whitehall not queued',
    use                        => 'govuk_urgent_priority',
    host_name                  => $::fqdn,
    notes_url                  => monitoring_docs_url(whitehall-scheduled-publishing),
    action_url                 => "https://${whitehall_hostname}${whitehall_scheduled_url}",
    check_period               => $check_period,
    attempts_before_hard_state => 10,
    retry_interval             => 1,
  }
}

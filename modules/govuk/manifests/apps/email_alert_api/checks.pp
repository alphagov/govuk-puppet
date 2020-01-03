# == Class: govuk::apps::email_alert_api:checks
#
# Various Icinga checks for Email Alert API.
#
class govuk::apps::email_alert_api::checks(
  $ensure = present,
) {

  delivery_attempt_status_check { 'internal_failure':
    ensure => $ensure,
  }

  delivery_attempt_status_check { 'technical_failure':
    ensure => $ensure,
  }

  @@icinga::check::graphite { 'email-alert-api-notify-email-send-request-success':
    host_name => $::fqdn,
    target    => 'summarize(sum(stats_counts.govuk.app.email-alert-api.*.notify.email_send_request.success),"1day")',
    args      => '--ignore-missing',
    warning   => '3200000', # 4,000,000 * 0.8
    critical  => '3600000', # 4,000,000 * 0.9
    from      => '3hours',
    desc      => 'email-alert-api - high number of email send requests',
  }

  @@icinga::check::graphite { 'email-alert-api-delivery-attempt-status-update':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(divideSeries(keepLastValue(stats.gauges.govuk.email-alert-api.delivery_attempt.pending_status_total), keepLastValue(stats.gauges.govuk.email-alert-api.delivery_attempt.total)),0)',
    warning   => '0.166',
    critical  => '0.25',
    from      => '1hour',
    desc      => 'email-alert-api - high number of delivery attempts have not received status updates',
  }
}

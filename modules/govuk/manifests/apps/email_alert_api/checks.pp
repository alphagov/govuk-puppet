# == Class: govuk::apps::email_alert_api:checks
#
# Various Icinga checks for Email Alert API.
#
class govuk::apps::email_alert_api::checks(
  $ensure = present,
) {

  sidekiq_queue_check {
    'send_email_transactional':
      latency_warning  => '300', # 5 minutes
      latency_critical => '600'; # 10 minutes

    'send_email_immediate':
      latency_warning  => '43200', # 12 hours
      latency_critical => '86400'; # 24 hours

    'send_email_immediate_high':
      latency_warning  => '10800', # 3 hours
      latency_critical => '86400'; # 24 hours

    'send_email_digest':
      latency_warning  => '43200', # 12 hours
      latency_critical => '86400'; # 24 hours
  }

  @@icinga::check::graphite { 'email-alert-api-unprocessed-content-changes':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(keepLastValue(averageSeries(stats.gauges.govuk.app.email-alert-api.*.content_changes.unprocessed_total)))',
    warning   => '0',
    critical  => '0',
    from      => '15minutes',
    desc      => 'email-alert-api - unprocessed content changes older than 2 hours',
    notes_url => monitoring_docs_url(email-alert-api-unprocessed-work),
  }

  @@icinga::check::graphite { 'email-alert-api-critical-digest-runs':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(keepLastValue(averageSeries(stats.gauges.govuk.app.email-alert-api.*.digest_runs.critical_total)))',
    warning   => '0',
    critical  => '0',
    from      => '15minutes',
    desc      => 'email-alert-api - incomplete digest runs older than 2 hours',
    notes_url => monitoring_docs_url(email-alert-api-unprocessed-work),
  }

  @@icinga::check::graphite { 'email-alert-api-unprocessed-messages':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(keepLastValue(averageSeries(stats.gauges.govuk.app.email-alert-api.*.messages.unprocessed_total)))',
    warning   => '0',
    critical  => '0',
    from      => '15minutes',
    desc      => 'email-alert-api - unprocessed messages older than 2 hours',
    notes_url => monitoring_docs_url(email-alert-api-unprocessed-work),
  }
}

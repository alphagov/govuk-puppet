# == Define: govuk::apps::email_alert_api::sidekiq_retry_size_check
#
# Creates an Icinga check which checks Graphite for number of messages
# on Sidekiq retry queues
#
# === Parameters
#
# [*ensure*]
#   Whether to enable the check.
#   Default: present
#
# [*title*]
#   The name of the sidekiq queue to check - retry_set_size.
#
# [*retry_size_warning*]
#   The number of messages on retry queue to trigger a warning.
#
# [*retry_size_critical*]
#   The number of messages on retry queue to trigger a critical alert.
#
define govuk::apps::email_alert_api::sidekiq_retry_size_check(
  $retry_size_warning,
  $retry_size_critical,
) {
  icinga::check::graphite { "check_email_alert_api_${title}":
    target    => 'transformNull(averageSeries(keepLastValue(stats.gauges.govuk.app.email-alert-api.*.workers.retry_set_size)), 0)',
    from      => '24hours',
    # Take an average over the most recent 36 datapoints, which at 5
    # seconds per datapoint is the last 3 minutes
    args      => '--dropfirst -36',
    warning   => $retry_size_warning,
    critical  => $retry_size_critical,
    desc      => 'email-alert-api: high number of messages on sidekiq retry queue',
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(email-alert-api-high-retry-queue-size),
  }
}

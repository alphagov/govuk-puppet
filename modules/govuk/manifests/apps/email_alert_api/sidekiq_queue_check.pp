# == Define: govuk::apps::email_alert_api::sidekiq_queue_checks
#
# Creates an Icinga check which checks Graphite for activity
# on Sidekiq queues
#
# === Parameters
#
# [*ensure*]
#   Whether to enable the check.
#   Default: present
#
# [*title*]
#   The name of the sidekiq queue to check.
#
# [*size_warning*]
#   The number of messages on a queue to trigger a warning.
#
# [*size_critical*]
#   The number of messages on a queue to trigger a critical alert.
#
define govuk::apps::email_alert_api::sidekiq_queue_check(
  $size_warning,
  $size_critical,
) {
  icinga::check::graphite { "check_email_alert_api_${title}_queue_size":
    target    => "transformNull(averageSeries(keepLastValue(stats.gauges.govuk.app.email-alert-api.*.workers.queues.${title}.enqueued)), 0)",
    from      => '24hours',
    # Take an average over the most recent 36 datapoints, which at 5
    # seconds per datapoint is the last 3 minutes
    args      => '--dropfirst -36',
    warning   => $size_warning,
    critical  => $size_critical,
    desc      => "email-alert-api: high number of messages on ${title} sidekiq queue",
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(email-alert-api-high-queue-size),
  }
}

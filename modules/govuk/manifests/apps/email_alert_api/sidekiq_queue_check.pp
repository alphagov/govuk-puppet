# == Define: govuk::apps::email_alert_api::sidekiq_queue_check
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
# [*latency_warning*]
#   The warning threshold for a sidekiq queue in minutes.
#
# [*latency_critical*]
#   The critical threshold for a sidekiq queue in minutes.
#
define govuk::apps::email_alert_api::sidekiq_queue_check(
  $latency_warning,
  $latency_critical,
) {
  icinga::check::graphite { "check_email_alert_api_${title}_queue_latency":
    target    => "transformNull(averageSeries(keepLastValue(stats.gauges.govuk.app.email-alert-api.*.workers.queues.${title}.latency)), 0)",
    from      => '15minutes',
    args      => '--ignore-missing',
    warning   => $latency_warning,
    critical  => $latency_critical,
    desc      => "email-alert-api: high latency for ${title} sidekiq queue",
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(email-alert-api-high-queue-latency),
  }
}

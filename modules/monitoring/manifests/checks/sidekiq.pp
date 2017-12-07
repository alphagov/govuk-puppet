# == Class: monitoring::checks::sidekiq
#
# Nagios alerts for sidekiq queue latency
#
#
class monitoring::checks::sidekiq {
  icinga::check::graphite { 'check_rummager_queue_latency':
    target              => 'keepLastValue(stats.gauges.govuk.app.rummager.workers.queues.default.latency)',
    warning             => 0.3,
    critical            => 15,
    use                 => 'govuk_normal_priority',
    # Use data from the last 24 hours, to avoid not getting any
    # datapoints back.
    from                => '24hours',
    # Take an average over the most recent 36 datapoints, which at 5
    # seconds per datapoint is the last 3 minutes
    args                => '--dropfirst -36',
    host_name           => $::fqdn,
    desc                => 'check rummager queue latency [in office hours]',
    notification_period => 'inoffice',
  }
}

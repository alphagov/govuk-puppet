# == Class: monitoring::checks::sidekiq
#
# Nagios alerts for sidekiq queue latency
#
# [*enable_signon_check*]
#   Enable monitoring for check_signon_queue_sizes
#
# [*enable_support_check*]
#   Enable monitoring for check_support_default_queue_size
#
#
class monitoring::checks::sidekiq (
  $enable_signon_check = true,
  $enable_support_check = true,
) {
  if $enable_signon_check {
    icinga::check::graphite { 'check_signon_queue_sizes':
      # Check signon background worker average queue sizes
      target    => 'transformNull(keepLastValue(stats.gauges.govuk.app.signon.*.workers.queues.*.enqueued), 0)',
      warning   => 30,
      critical  => 50,
      desc      => 'signon background worker queue size unexpectedly large',
      host_name => $::fqdn,
      # Get the data over a 5 day period. As the sidekiq middleware
      # only reports values when jobs come through, there can be large
      # periods of empty data. Setting this to 5 days should avoid too
      # many false positives from not much activity, while also ensuring
      # that if there is no data for longer than 5 days, the alert
      # will fire with UNKNOWN.
      from      => '5days',
      # Drop all but the last 60 datapoints (at 5 seconds per datapoint,
      # this is 5 minutes), so that this alert reflects what is going on
      # currently.
      args      => '--dropfirst -60',
    }
  }

  if $enable_support_check {
    icinga::check::graphite { 'check_support_default_queue_size':
      target    => 'transformNull(averageSeries(keepLastValue(stats.gauges.govuk.app.support.*.workers.queues.default.enqueued)), 0)',
      from      => '24hours',
      # Take an average over the most recent 36 datapoints, which at 5
      # seconds per datapoint is the last 3 minutes
      args      => '--dropfirst -36',
      warning   => 10,
      critical  => 20,
      desc      => 'support app background processing: unexpectedly large default queue size',
      host_name => $::fqdn,
    }
  }
}

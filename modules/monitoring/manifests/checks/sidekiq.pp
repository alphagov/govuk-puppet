# == Class: monitoring::checks::sidekiq
#
# Nagios alerts for sidekiq queue latency
#
#
class monitoring::checks::sidekiq {

  $graphite_target = 'stats.gauges.govuk.app.rummager.workers.queues.default.latency'

  icinga::check::graphite { 'check_rummager_queue_latency':
    target              => $graphite_target,
    warning             => 0.3,
    critical            => 0.6,
    use                 => 'govuk_normal_priority',
    from                => '3minutes',
    host_name           => $::fqdn,
    desc                => 'check rummager queue latency [in office hours]',
    notification_period => 'inoffice',
  }
}

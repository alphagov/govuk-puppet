# == Class: monitoring::checks::accounts_slos
#
# Nagios alerts for Account Team SLOs
#
# === Parameters
#
# [*enabled*]
#   This variable enables to define whether to perform Account SLO checks. [This is set to 'true' by default.]
class monitoring::checks::accounts_slos (
  $enabled = true,
  ){
  if $enabled {
    $http_bad_metric = 'sumSeries(transformNull(stats_counts.*.nginx_logs.account-api.http_{422,5*}))'
    $http_all_metric = 'sumSeries(transformNull(stats_counts.*.nginx_logs.account-api.http_*))'
    $alert_warning_high_http_error_rate = 0.01

    @@icinga::check::graphite { 'check_slo_error_rate_10_min_accounts':
      target         => "movingMedian(divideSeries(${http_bad_metric},${http_all_metric}),\"30s\")",
      from           => '10mins',
      warning        => $alert_warning_high_http_error_rate,
      critical       => 1,
      desc           => 'HTTP Error on GOV.UK Accounts has exceeded an acceptable threshold across the last 10 minutes',
      notes_url      => monitoring_docs_url(slo-rate-checks-account),
      host_name      => $::fqdn,
      contact_groups => ['slack-channel-accounts-tech'],
      # Drop all but the last 6 datapoints (at 5 seconds per
      # datapoint, this is 30 seconds)
      args           => '--dropfirst -6',
  }

    $latency_bad_metric = 'transformNull(offset(scale(removeBelowValue(maxSeries(stats.timers.*.nginx_logs.account-api.time_request.upper_90),0.850),0),1))'
    $latency_all_metric = 'offset(scale(transformNull(maxSeries(stats.timers.*.nginx_logs.account-api.time_request.upper_90)),0),1)'
    $alert_warning_slow_http_response_rate = 0.01

    @@icinga::check::graphite { 'check_slo_latency_rate_10_min_accounts':
      target         => "movingMedian(divideSeries(${latency_bad_metric},${latency_all_metric}),\"30s\")",
      from           => '10mins',
      warning        => $alert_warning_slow_http_response_rate,
      critical       => 1,
      desc           => 'Latency on GOV.UK Accounts has exceeded an acceptable threshold across the last 10 minutes',
      notes_url      => monitoring_docs_url(slo-rate-checks-account),
      host_name      => $::fqdn,
      contact_groups => ['slack-channel-accounts-tech'],
      # Drop all but the last 6 datapoints (at 5 seconds per
      # datapoint, this is 30 seconds)
      args           => '--dropfirst -6',
    }
  }
}

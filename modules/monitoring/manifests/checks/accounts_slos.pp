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
    # Warn when error rate exeeds 1% in any 10 minute rolling window
    $alert_warning_high_http_error_rate = 0.01
    # Turns out puppet gets sad when we don't have a critical, so set it so something impossible.
    $critical_warning_high_http_error_rate = 2

    $http_bad_metric = 'sumSeries(transformNull(stats_counts.*.nginx_logs.account-api.http_{422,5*}))'
    $http_all_metric = 'sumSeries(transformNull(stats_counts.*.nginx_logs.account-api.http_*))'

    @@icinga::check::graphite { 'check_slo_error_rate_10_min_accounts':
      target         => "divideSeries(integral(${http_bad_metric}),integral(${http_all_metric}))",
      from           => '10mins',
      warning        => $alert_warning_high_http_error_rate,
      critical       => $critical_warning_high_http_error_rate,
      desc           => 'HTTP Error on GOV.UK Accounts has exceeded an acceptable threshold across the last 10 minutes',
      notes_url      => monitoring_docs_url(slo-rate-checks-account),
      host_name      => $::fqdn,
      contact_groups => ['slack-channel-accounts-tech'],
  }

    $latency_bad_metric = 'transformNull(offset(scale(removeBelowValue(maxSeries(stats.timers.*.nginx_logs.account-api.time_request.upper_90),0.850),0),1))'
    $latency_all_metric = 'offset(scale(transformNull(maxSeries(stats.timers.*.nginx_logs.account-api.time_request.upper_90)),0),1)'

    # Warn when more than 1% of requests are 'too slow' in any 10 minute rolling window
    $alert_warning_slow_http_response_rate = 0.01
    # Turns out puppet gets sad when we don't have a critical, so set it so something impossible.
    $alert_critical_slow_http_response_rate = 2

    @@icinga::check::graphite { 'check_slo_latency_rate_10_min_accounts':
      target         => "divideSeries(integral(${latency_bad_metric}),integral(${latency_all_metric}))",
      from           => '10mins',
      warning        => $alert_warning_slow_http_response_rate,
      critical       => $alert_critical_slow_http_response_rate,
      desc           => 'Latency on GOV.UK Accounts has exceeded an acceptable threshold across the last 10 minutes',
      notes_url      => monitoring_docs_url(slo-rate-checks-account),
      host_name      => $::fqdn,
      contact_groups => ['slack-channel-accounts-tech'],
    }
  }
}

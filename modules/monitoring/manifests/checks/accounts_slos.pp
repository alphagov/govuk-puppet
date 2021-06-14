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
) {
  if $enabled {
    $error_budget_warning = 50 # Warn when <50% of budget remains
    $error_budget_critical = 25 # Declare critical when <25% of budget remains

    $latency_bad_metric = 'transformNull(offset(scale(removeBelowValue(maxSeries(stats.timers.*.nginx_logs.account-api.time_request.upper_90),0.850),0),1))'
    $latency_all_metric = 'offset(scale(transformNull(maxSeries(stats.timers.*.nginx_logs.account-api.time_request.upper_90)),0),1)'
    $latency_error_budget = '0.01'

    @@icinga::check::graphite { 'check_latency_error_budget_remaining':
      target         => "scale(asPercent(scale(offset(divideSeries(integral(${latency_bad_metric}),integral(${latency_all_metric})),-${latency_error_budget}),-1),${latency_error_budget}),-1)",
      warning        => "-${error_budget_warning}",
      critical       => "-${error_budget_critical}",
      desc           => 'Latency Error budget for GOV.UK Accounts has fallen below acceptable thresholds',
      notes_url      => monitoring_docs_url(slo-error-budget-accounts),
      # Get the data over a 28 day period. The graphite metrics record on this
      # basis, if we go for a shorter window they tend to exaggerate recent small faults.
      from      => '28days',
      host_name      => $::fqdn,
      contact_groups => ['slack-channel-accounts-tech'],
    }

    $http_bad_metric = 'sumSeries(transformNull(stats_counts.*.nginx_logs.account-api.http_{422,5*}))'
    $http_all_metric = 'sumSeries(transformNull(stats_counts.*.nginx_logs.account-api.http_*))'
    $http_error_budget = '0.01'

    @@icinga::check::graphite { 'check_http_error_budget_remaining':
      target         => "scale(asPercent(scale(offset(divideSeries(integral(${http_bad_metric}),integral(${http_all_metric})),-${http_error_budget}),-1),${http_error_budget}),-1)",
      warning        => "-${error_budget_warning}",
      critical       => "-${error_budget_critical}",
      desc           => 'HTTP Error budget for GOV.UK Accounts has fallen below acceptable thresholds',
      notes_url      => monitoring_docs_url(slo-error-budget-accounts),
      # Get the data over a 28 day period. The graphite metrics record on this
      # basis, if we go for a shorter window they tend to exaggerate recent small faults.
      from      => '28days',
      host_name      => $::fqdn,
      contact_groups => ['slack-channel-accounts-tech'],
    }
  }
}

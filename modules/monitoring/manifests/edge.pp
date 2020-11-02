# == Class: monitoring::edge
#
# This class sets up monitoring at the edge of the Content
# Delivery Network which serves GOV.UK.
#
# === Parameters
#
# [*enabled*]
#   Should monitoring of the CDN edge be enabled?
#
class monitoring::edge (
  $enabled = false,
) {

  if $enabled {
    $graphite_5xx_warning_target = "movingMedian(transformNull(${::fqdn_metrics}.cdn_fastly-govuk.requests-status_5xx,0),\"5min\")"
    $graphite_5xx_critical_target = "movingMedian(transformNull(${::fqdn_metrics}.cdn_fastly-govuk.requests-status_5xx,0),\"10min\")"

    icinga::check::graphite { "fastly_5xx_rate_on_${::hostname}_warning":
      target    => $graphite_5xx_warning_target,
      desc      => 'Fastly error rate for GOV.UK',
      warning   => 0.05,
      critical  => 999999, # the metric for this alert is only used for warnings
      host_name => $::fqdn,
      from      => '8minutes', # average over three 5 min windows
      notes_url => monitoring_docs_url(fastly-error-rate),
    }

    icinga::check::graphite { "fastly_5xx_rate_on_${::hostname}":
      target    => $graphite_5xx_critical_target,
      desc      => 'Fastly error rate for GOV.UK',
      warning   => 0.1, # the metric for this alert is only used for criticals
      critical  => 0.1,
      host_name => $::fqdn,
      from      => '13minutes', # average of three 10 min windows
      notes_url => monitoring_docs_url(fastly-error-rate),
    }
  }

}

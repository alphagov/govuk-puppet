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
    icinga::check::graphite { "fastly_5xx_rate_on_${::hostname}":
      target    => "${::fqdn_metrics}.cdn_fastly-govuk.requests-status_5xx",
      desc      => 'Fastly error rate for GOV.UK',
      warning   => 0.05,
      critical  => 0.1,
      host_name => $::fqdn,
      from      => '30minutes',
      notes_url => monitoring_docs_url('fastly-error-rate', true),
    }
  }

}

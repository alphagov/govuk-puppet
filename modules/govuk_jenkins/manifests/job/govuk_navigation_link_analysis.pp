# == Class: govuk_jenkins::job::govuk_navigation_link_analysis
#
# Monthly analysis of links displayed in the new navigation pages. The output of
# this is needed for Performance Analysts to produce reports on how the new
# navigation is performing.
#
# === Parameters
#
# [*rate_limit_token*]
#   Sets the header "Rate-Limit-Token" which ensures that the tagging monitor is
#   whitelisted by the rate limiting function (receiving 429 status)
#
# [*private_key_id*]
#   Specific to access the Google API.
#
# [*private_key*]
#   Specific to access the Google API.
#
# [*client_email*]
#   Specific to access the Google API.
#
# [*client_email*]
#   Specific to access the Google API.
#
# [*client_id*]
#   Specific to access the Google API.
#
# [*client_x509_cert_url*]
#   Specific to access the Google API.
#
class govuk_jenkins::job::govuk_navigation_link_analysis (
  $rate_limit_token = undef,
  $private_key_id = undef,
  $private_key = undef,
  $client_email = undef,
  $client_id = undef,
  $client_x509_cert_url = undef,
) {

  file { '/var/lib/jenkins/govuk_navigation_link_analysis/govuk-tagging-monitor-2f614b9b92c2.json':
    ensure  => present,
    content => template('govuk_jenkins/google_api/credentials.json.erb'),
    owner   => 'jenkins',
    group   => 'jenkins',
  }

  file { '/etc/jenkins_jobs/jobs/govuk_navigation_link_analysis.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/govuk_navigation_link_analysis.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

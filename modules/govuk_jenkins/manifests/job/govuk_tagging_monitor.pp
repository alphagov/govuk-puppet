# == Class: govuk_jenkins::job::govuk_tagging_monitor
#
# Monitor GOV.UK navigation pages to find invalid pages that we shouldn't
# display to users. It also raises alerts when navigation pages exceed the
# number of allowed links, so a content designer can act on those. The ruby
# script handles slack notifications.
#
# === Parameters
#
# [*rate_limit_token*]
#   Sets the header "Rate-Limit-Token" which ensures that the tagging monitor is
#   whitelisted by the rate limiting function (receiving 429 status)
#
class govuk_jenkins::job::govuk_tagging_monitor (
  $rate_limit_token = undef,
) {

  file { '/etc/jenkins_jobs/jobs/govuk_tagging_monitor.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/govuk_tagging_monitor.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

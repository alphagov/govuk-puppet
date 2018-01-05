# == Class: govuk_jenkins::jobs::govuk_cdn_nightly_2xx_status_collection
#
# Collect all GOV.UK URLs that returned a 2XX status for yesterday's site activity
#
#
# === Parameters:
#
class govuk_jenkins::jobs::govuk_cdn_nightly_2xx_status_collection {
  file { '/etc/jenkins_jobs/jobs/govuk_cdn_nightly_2xx_status_collection.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/govuk_cdn_nightly_2xx_status_collection.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

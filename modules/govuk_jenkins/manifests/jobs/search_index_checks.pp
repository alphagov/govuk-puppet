# == Class: govuk_jenkins::jobs::search_index_checks
#
# Monitor the GOV.UK search indexes and report data to statsd
#
class govuk_jenkins::jobs::search_index_checks {

  file { '/etc/jenkins_jobs/jobs/search_index_checks.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/search_index_checks.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

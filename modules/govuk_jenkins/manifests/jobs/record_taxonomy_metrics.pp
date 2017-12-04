# == Class: govuk_jenkins::jobs::record_taxonomy_metrics
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::record_taxonomy_metrics {
  file { '/etc/jenkins_jobs/jobs/record_taxonomy_metrics.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/record_taxonomy_metrics.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

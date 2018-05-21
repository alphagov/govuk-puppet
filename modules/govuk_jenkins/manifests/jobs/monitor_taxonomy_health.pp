# == Class: govuk_jenkins::jobs::monitor_taxonomy_health
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::monitor_taxonomy_health {
  file { '/etc/jenkins_jobs/jobs/monitor_taxonomy_health.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/monitor_taxonomy_health.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

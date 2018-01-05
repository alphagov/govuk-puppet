# == Class: govuk_jenkins::jobs::trigger_data_sync_complete
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::trigger_data_sync_complete () {
  file { '/etc/jenkins_jobs/jobs/trigger_data_sync_complete.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/trigger_data_sync_complete.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

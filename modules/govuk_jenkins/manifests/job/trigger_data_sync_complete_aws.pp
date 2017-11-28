# == Class: govuk_jenkins::job::trigger_data_sync_complete_aws
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::trigger_data_sync_complete_aws () {
  file { '/etc/jenkins_jobs/jobs/trigger_data_sync_complete_aws.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/trigger_data_sync_complete_aws.yaml.erb'),
    notify  => Exec['jenkins_job_update'],
  }
}

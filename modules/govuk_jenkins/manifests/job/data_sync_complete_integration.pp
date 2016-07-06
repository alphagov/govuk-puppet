# == Class: govuk_jenkins::job::data_sync_complete_integration
#
# Create a Jenkins job that is triggered when the data sync from production finishes.
# This is specific to the Integration environment.
#
# === Parameters
#
# [*auth_token*]
#   Token to allow this job to be triggered remotely
#
class govuk_jenkins::job::data_sync_complete_integration (
  $auth_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/data_sync_complete.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/data_sync_complete_integration.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

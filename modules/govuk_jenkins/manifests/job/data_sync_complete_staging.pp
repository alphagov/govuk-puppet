# == Class: govuk_jenkins::job::data_sync_complete_staging
#
# Create a Jenkins job that is triggered when the data sync from production finishes.
# This is specific to the Staging environment.
#
# === Parameters
#
# [*auth_token*]
#   Token to allow this job to be triggered remotely
#
# [*signon_domains_to_migrate*]
#   An array of hashes containing `old` (the existing Signon domain) and `new`,
#   (what that domain should be changed to when synced).
#
class govuk_jenkins::job::data_sync_complete_staging (
  $auth_token = undef,
  $signon_domains_to_migrate = [],
) {
  file { '/etc/jenkins_jobs/jobs/data_sync_complete.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/data_sync_complete_staging.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

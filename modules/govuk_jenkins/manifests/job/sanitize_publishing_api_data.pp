# == Class:
# govuk_jenkins::job::sanitize_publishing_api_data
#
# === Parameters
#
# [*auth_token*]
#   Token to allow this job to be triggered remotely
#
class govuk_jenkins::job::sanitize_publishing_api_data (
  $auth_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/sanitize_publishing_api_data.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/sanitize_publishing_api_data.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

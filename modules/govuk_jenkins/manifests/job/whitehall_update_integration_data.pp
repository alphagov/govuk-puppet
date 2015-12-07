# == Class: govuk_jenkins::job::whitehall_update_integration_data
#
# === Parameters
#
# [*auth_token*]
#   Token to allow this job to be triggered remotely
#
# [*whitehall_update_integration_data*]
#   Whitehall MySQL password
#
class govuk_jenkins::job::whitehall_update_integration_data (
  $auth_token = undef,
  $whitehall_mysql_password,
) {
  file { '/etc/jenkins_jobs/jobs/whitehall_update_integration_data.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/integration/whitehall_update_integration_data.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

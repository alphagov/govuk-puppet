# == Class: govuk_jenkins::job::integration_deploy
#
# Creates jobs that enables kicking off deploys on Integration
#
# === Parameters
#
# [*applications*]
#   Array of applications that are available to kick off deploys on Integration.
#
# [*jenkins_integration_api_user*]
#   The username used to authenticate with the deployment Jenkins in Integration.
#
# [*jenkins_integration_api_password*]
#   The password used to authenticate with the deployment Jenkins in Integration.
#
class govuk_jenkins::job::integration_deploy (
  $applications = undef,
  $jenkins_integration_api_user = undef,
  $jenkins_integration_api_password = undef,
) {
  file { '/etc/jenkins_jobs/jobs/integration_app_deploy.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/integration_app_deploy.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  file { '/etc/jenkins_jobs/jobs/integration_puppet_deploy.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/integration_puppet_deploy.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

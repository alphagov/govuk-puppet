# == Class: govuk_jenkins::jobs::integration_deploy
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
# [*jenkins_integration_aws_api_user*]
#   The username used to authenticate with the deployment Jenkins in Integration AWS.
#
# [*jenkins_integration_aws_api_password*]
#   The password used to authenticate with the deployment Jenkins in Integration AWS.
#
# [*aws_deploy_url*]
#   The URL of the AWS Integration stack. This may potentially change in the future
#   so it is added as a parameter.
#
# [*puppet_auth_token*]
#   This token is used to authenticate with the deploy job in Integration.
#
class govuk_jenkins::jobs::integration_deploy (
  $applications = undef,
  $jenkins_integration_api_user = undef,
  $jenkins_integration_api_password = undef,
  $jenkins_integration_aws_api_user = undef,
  $jenkins_integration_aws_api_password = undef,
  $aws_deploy_url = 'deploy.blue.integration.govuk.digital',
  $puppet_auth_token = undef,
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

  file { '/etc/jenkins_jobs/jobs/integration_licensify_deploy.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/integration_licensify_deploy.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  file { '/etc/jenkins_jobs/jobs/integration_router_data_deploy.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/integration_router_data_deploy.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

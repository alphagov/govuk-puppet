# == Class: govuk_jenkins::jobs::deploy_app_downstream
#
# Creates jobs that enables kicking off deploys in a downstream environment.
#
# === Parameters
#
# [*applications*]
#   Array of applications that are available to kick off downstream deploys.
#
# [*jenkins_downstream_api_user*]
#   The username used to authenticate with the downstream deployment Jenkins.
#
# [*jenkins_downstream_api_password*]
#   The password used to authenticate with the downstream deployment Jenkins.
#
# [*jenkins_integration_aws_api_user*]
#   The username used to authenticate with the downstream deployment Jenkins in AWS.
#
# [*jenkins_integration_aws_api_password*]
#   The password used to authenticate with the downstream deployment Jenkins in AWS.
#
# [*deploy_url*]
#   The URL of the downstream Jenkins.
#
# [*aws_deploy_url*]
#   The URL of the downstream AWS Jenkins.
#
class govuk_jenkins::jobs::deploy_app_downstream (
  $applications = undef,
  $jenkins_downstream_api_user = undef,
  $jenkins_downstream_api_password = undef,
  $jenkins_downstream_aws_api_user = undef,
  $jenkins_downstream_aws_api_password = undef,
  $deploy_url = undef,
  $aws_deploy_url = undef,
) {
  file { '/etc/jenkins_jobs/jobs/deploy_app_downstream.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_app_downstream.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

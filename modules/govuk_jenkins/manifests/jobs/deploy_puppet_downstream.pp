# == Class: govuk_jenkins::jobs::deploy_puppet_downstream
#
# Creates a jobs that enables kicking off Puppet deploys downstream
#
# === Parameters
#
# [*jenkins_downstream_api_user*]
#   The username used to authenticate with the deployment downstream Jenkins.
#
# [*jenkins_downstream_api_password*]
#   The password used to authenticate with the deployment downstream Jenkins.
#
# [*jenkins_downstream_aws_api_user*]
#   The username used to authenticate with the deployment downstream Jenkins in AWS.
#
# [*jenkins_downstream_aws_api_password*]
#   The password used to authenticate with the deployment downstream Jenkins in AWS.
#
# [*aws_deploy_url*]
#   The URL of the AWS Integration stack. This may potentially change in the future
#   so it is added as a parameter.
#
# [*deploy_url*]
#   The URL of the CI stack to deploy Puppet changes into.
#
# [*puppet_auth_token*]
#   This token is used to authenticate with the downstream deploy job.
#
class govuk_jenkins::jobs::deploy_puppet_downstream (
  $jenkins_downstream_api_user = undef,
  $jenkins_downstream_api_password = undef,
  $jenkins_downstream_aws_api_user = undef,
  $jenkins_downstream_aws_api_password = undef,
  $aws_deploy_url = 'deploy.integration.publishing.service.gov.uk',
  $deploy_url = 'ci-deploy.integration.publishing.service.gov.uk',
  $puppet_auth_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/deploy_puppet_downstream.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_puppet_downstream.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

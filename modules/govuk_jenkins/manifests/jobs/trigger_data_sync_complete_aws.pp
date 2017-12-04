# == Class: govuk_jenkins::jobs::trigger_data_sync_complete_aws
#
# Create a file on disk that can be parsed by jenkins-job-builder
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
class govuk_jenkins::jobs::trigger_data_sync_complete_aws (
  $jenkins_integration_aws_api_user = undef,
  $jenkins_integration_aws_api_password = undef,
  $aws_deploy_url = 'deploy.blue.integration.govuk.digital',
) {
  file { '/etc/jenkins_jobs/jobs/trigger_data_sync_complete_aws.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/trigger_data_sync_complete_aws.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

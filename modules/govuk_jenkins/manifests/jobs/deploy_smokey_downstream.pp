# == Class: govuk_jenkins::jobs::deploy_smokey_downstream
#
# Creates a jobs that enables kicking off Smokey_Deploy downstream
#
# === Parameters
#
# [*jenkins_downstream_api_user*]
#   The username used to authenticate with the deployment downstream Jenkins.
#
# [*jenkins_downstream_api_password*]
#   The password used to authenticate with the deployment downstream Jenkins.
#
# [*deploy_url*]
#   The URL of the downstream Jenkins.
#
# [*puppet_auth_token*]
#   This token is used to authenticate with the downstream deploy job.
#
class govuk_jenkins::jobs::deploy_smokey_downstream (
  $jenkins_downstream_api_user = undef,
  $jenkins_downstream_api_password = undef,
  $deploy_url = undef,
  $puppet_auth_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/deploy_smokey_downstream.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_smokey_downstream.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

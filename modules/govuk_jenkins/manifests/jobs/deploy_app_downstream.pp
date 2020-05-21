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
# [*deploy_url*]
#   The URL of the downstream Jenkins.
#
# [*github_api_token*]
#   The API token used to avoid rate limiting for GitHub API calls.
#
class govuk_jenkins::jobs::deploy_app_downstream (
  $applications = undef,
  $jenkins_downstream_api_user = undef,
  $jenkins_downstream_api_password = undef,
  $deploy_url = undef,
  $github_api_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/deploy_app_downstream.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_app_downstream.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

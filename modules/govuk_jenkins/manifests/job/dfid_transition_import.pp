# == Class: govuk_jenkins::job::dfid_transition_import
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*asset_manager_bearer_token*]
#   The bearer token to use when communicating with Asset Manager.
#   Default: undef
class govuk_jenkins::job::dfid_transition_import (
  $publishing_api_bearer_token = undef,
  $asset_manager_bearer_token = undef,
  $redis_host = undef,
  $redis_port = 6379
) {

  file {
    '/etc/jenkins_jobs/jobs/dfid_transition_import.yaml':
      ensure  => present,
      content => template('govuk_jenkins/jobs/dfid_transition_import.yaml.erb'),
      notify  => Exec['jenkins_jobs_update'];
  }
}

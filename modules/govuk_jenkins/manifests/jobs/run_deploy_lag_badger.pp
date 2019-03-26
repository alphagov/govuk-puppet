# == Class: govuk_jenkins::jobs::run_deploy_lag_badger
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*github_token*]
#   A GitHub access token with permission to access private repos
#
class govuk_jenkins::jobs::run_deploy_lag_badger (
  $github_token = undef,
) {

  file { '/etc/jenkins_jobs/jobs/run_deploy_lag_badger.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/run_deploy_lag_badger.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

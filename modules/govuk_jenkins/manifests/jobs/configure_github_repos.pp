# == Class: govuk_jenkins::jobs::configure_github_repos
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*github_token*]
#   A GitHub access token with `repo` and `admin:repo_hook` permissions
#
class govuk_jenkins::jobs::configure_github_repos (
  $github_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/configure_github_repos.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/configure_github_repos.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

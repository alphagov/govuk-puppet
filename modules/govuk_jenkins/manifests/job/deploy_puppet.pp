# == Class: govuk_jenkins::job::deploy_puppet
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*auth_token*]
#   Token which will allow this job to be triggered remotely
#
# [*commitish*]
#   The commitish that the job should deploy by default. Defaults to 'release'
#
class govuk_jenkins::job::deploy_puppet (
  $auth_token = undef,
  $commitish   = 'release',
  $app_domain = hiera('app_domain')
) {
  $slack_team_domain = 'govuk'
  $slack_room = 'govuk-deploy'
  $slack_build_server_url = "https://deploy.${app_domain}/"

  file { '/etc/jenkins_jobs/jobs/deploy_puppet.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_puppet.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

# == Class: govuk_jenkins::jobs::deploy_puppet
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*auth_token*]
#   Token which will allow this job to be triggered remotely
#
# [*enable_slack_notifications*]
#   Whether slack should be notified about this job
#
# [*commitish*]
#   The commitish that the job should deploy by default. Defaults to 'release'
#
# [*deploy_environment*]
#   The name of the environment in which Puppet is being deployed.
#   This is used to make the Slack message more useful.
#
class govuk_jenkins::jobs::deploy_puppet (
  $auth_token = undef,
  $commitish   = 'release',
  $enable_slack_notifications = false,
  $deploy_environment = undef,
) {
  $environment_variables = $govuk_jenkins::environment_variables
  $slack_team_domain = 'gds'
  $slack_room = 'govuk-deploy'
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')
  $slack_build_server_url = "https://${deploy_jenkins_domain}/"

  file { '/etc/jenkins_jobs/jobs/deploy_puppet.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_puppet.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

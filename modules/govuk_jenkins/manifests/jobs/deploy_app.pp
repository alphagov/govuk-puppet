# == Class: govuk_jenkins::jobs::deploy_app
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*app_domain*]
#   The hostname where applications are served from
#
# [*auth_token*]
#   Token which will allow this job to be triggered remotely
#
# [*ci_deploy_jenkins_api_key*]
#   API key to download build artefacts from CI servers
#
# [*notify_release_app*]
#   Set to true to ensure the Release app is updated with the latest deployment
#   release version.
#
# [*enable_slack_notifications*]
#   Set to true to post details of a deployment into a Slack channel.
#
# [*continuous_deployment_downstream*]
#   Set to true to trigger Deploy_App in a downstream environment, on success.
#
class govuk_jenkins::jobs::deploy_app (
  $app_domain = undef,
  $auth_token = undef,
  $ci_deploy_jenkins_api_key = undef,
  $applications = undef,
  $graphite_host = 'graphite.cluster',
  $graphite_port = '80',
  $notify_release_app = true,
  $enable_slack_notifications = true,
  $continuous_deployment_downstream = false,
) {
  if $::aws_migration {
    $aws_deploy = true
  }

  file { '/etc/jenkins_jobs/jobs/deploy_app.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_app.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

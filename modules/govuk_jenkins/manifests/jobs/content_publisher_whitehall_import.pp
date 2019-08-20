# == Class: govuk_jenkins::jobs::content_publisher_whitehall_import
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::content_publisher_whitehall_import (
  $enable_slack_notifications = false,
  $app_domain = hiera('app_domain'),
  $cron_schedule = '0 9 * * 1-5'
) {
  $environment_variables = $govuk_jenkins::environment_variables
  $slack_team_domain = 'gds'
  $slack_room = 'govuk-pubworkflow-dev'
  $slack_build_server_url = "https://deploy.${app_domain}/"

  file { '/etc/jenkins_jobs/jobs/content_publisher_whitehall_import.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/content_publisher_whitehall_import.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

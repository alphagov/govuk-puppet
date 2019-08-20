# == Class: govuk_jenkins::jobs::deploy_cdn
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::deploy_cdn(
  $app_domain = hiera('app_domain'),
  $enable_slack_notifications = false,
) {

  $environment_variables = $govuk_jenkins::environment_variables
  $slack_team_domain = 'gds'
  $slack_room = 'govuk-deploy'
  $slack_build_server_url = "https://deploy.${app_domain}/"

  file { '/etc/jenkins_jobs/jobs/deploy_cdn.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_cdn.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

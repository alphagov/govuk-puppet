# == Class: govuk_jenkins::jobs::deploy_cdn
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::deploy_cdn(
  $enable_slack_notifications = false,
  $services = [],
) {

  $environment_variables = $govuk_jenkins::environment_variables
  $slack_team_domain = 'gds'
  $slack_room = 'govuk-deploy'
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')
  $slack_build_server_url = "https://${deploy_jenkins_domain}/"

  file { '/etc/jenkins_jobs/jobs/deploy_cdn.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_cdn.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

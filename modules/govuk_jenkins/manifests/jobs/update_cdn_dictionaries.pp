# == Class: govuk_jenkins::jobs::update_cdn_dictionaries
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::update_cdn_dictionaries(
  $app_domain = hiera('app_domain'),
) {

  $slack_team_domain = 'govuk'
  $slack_room = 'govuk-deploy'
  $slack_build_server_url = "https://deploy.${app_domain}/"

  file { '/etc/jenkins_jobs/jobs/update_cdn_dictionaries.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/update_cdn_dictionaries.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

# == Class: govuk_jenkins::jobs::publish_special_routes
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::publish_special_routes(
  $publishing_api_bearer_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/publish_special_routes.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/publish_special_routes.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

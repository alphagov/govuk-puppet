# == Class: govuk_jenkins::job::production_deploy
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::production_deploy (
  $ci_deploy_jenkins_api_key = undef,
) {
  file { '/etc/jenkins_jobs/jobs/production_deploy.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production_deploy.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

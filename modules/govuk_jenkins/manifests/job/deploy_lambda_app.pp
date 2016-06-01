# == Class: govuk_jenkins::job::deploy_lambda_app
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::deploy_lambda_app (
  $lambda_apps = [],
) {
  validate_array($lambda_apps)

  file { '/etc/jenkins_jobs/jobs/deploy_lambda_app.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_lambda_app.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

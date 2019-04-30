# == Class: govuk_jenkins::jobs::check_sentry_errors
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::check_sentry_errors (
  $sentry_auth_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/check_sentry_errors.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/check_sentry_errors.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

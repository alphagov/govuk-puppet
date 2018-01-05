# == Class: govuk_jenkins::jobs::check_content_store
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::check_content_store {
  file { '/etc/jenkins_jobs/jobs/check_content_store.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/check_content_store.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

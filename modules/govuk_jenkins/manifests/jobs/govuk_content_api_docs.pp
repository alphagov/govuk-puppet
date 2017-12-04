# == Class: govuk_jenkins::jobs::govuk_content_api_docs
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::govuk_content_api_docs {
  file { '/etc/jenkins_jobs/jobs/govuk_content_api_docs.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/govuk_content_api_docs.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

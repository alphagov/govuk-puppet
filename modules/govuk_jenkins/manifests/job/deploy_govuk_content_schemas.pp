# == Class: govuk_jenkins::job::deploy_govuk_content_schemas
#
# Create a file on disk that can be parsed by jenkins-job-builder
class govuk_jenkins::job::deploy_govuk_content_schemas {
  file { '/etc/jenkins_jobs/jobs/deploy_govuk_content_schemas.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_govuk_content_schemas.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

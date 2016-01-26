# == Class: govuk_jenkins::job::departmental_projects_publish_existing_content
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::departmental_projects_publish_existing_content {
  file { '/etc/jenkins_jobs/jobs/departmental_projects_publish_existing_content.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/departmental_projects_publish_existing_content.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

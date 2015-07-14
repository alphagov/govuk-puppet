# == Class: govuk_jenkins::job::service-manual_rebuild_search_index
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::service_manual_rebuild_search_index {
  file { '/etc/jenkins_jobs/jobs/service_manual_rebuild_search_index.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/service_manual_rebuild_search_index.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

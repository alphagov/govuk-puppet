# == Class: govuk_jenkins::job::production::whitehall_rebuild_elasticsearch_index
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::production::whitehall_rebuild_elasticsearch_index {
  file { '/etc/jenkins_jobs/jobs/whitehall_rebuild_elasticsearch_index.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production/whitehall_rebuild_elasticsearch_index.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

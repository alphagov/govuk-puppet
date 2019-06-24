# == Class: govuk_jenkins::jobs::transition_import_hits
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::transition_import_hits {
  file { '/etc/jenkins_jobs/jobs/transition_import_hits.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/transition_import_hits.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

# == Class: govuk_jenkins::job::staging::data_sync_complete
#
# Create a file on disk that can be parsed by data_sync_complete
#
class govuk_jenkins::job::staging::data_sync_complete {
  file { '/etc/jenkins_jobs/jobs/data_sync_complete.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/staging/data_sync_complete.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

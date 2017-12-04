# == Class: govuk_jenkins::jobs::build_offsite_backup
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::build_offsite_backup {
  file { '/etc/jenkins_jobs/jobs/build_offsite_backup.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/build_offsite_backup.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

# == Class: govuk_jenkins::job::gds_production_backup
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::gds_production_backup {
  file { '/etc/jenkins_jobs/jobs/gds_production_backup.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production/gds_production_backup.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

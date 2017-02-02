# == Class: govuk_jenkins::job::performance_platform_data_sync
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::performance_platform_data_sync {
  file { '/etc/jenkins_jobs/jobs/performance_platform_data_sync.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/performance_platform_data_sync.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

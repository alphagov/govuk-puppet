# == Class: govuk_jenkins::job::deploy_smokey_to_monitoring
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::deploy_smokey_to_monitoring {
  file { '/etc/jenkins_jobs/jobs/deploy_smokey_to_monitoring.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_smokey_to_monitoring.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

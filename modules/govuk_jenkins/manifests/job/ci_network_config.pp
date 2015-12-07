# == Class: govuk_jenkins::job::ci_network_config.pp
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::ci_network_config {
  file { '/etc/jenkins_jobs/jobs/ci_network_config.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production/ci_network_config.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

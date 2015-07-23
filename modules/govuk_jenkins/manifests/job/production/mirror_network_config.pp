# == Class: govuk_jenkins::job::production::mirror_network_config
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::production::mirror_network_config {
  file { '/etc/jenkins_jobs/jobs/mirror_network_config.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production/mirror_network_config.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

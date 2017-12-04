# == Class: govuk_jenkins::jobs::mirror_network_config
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::mirror_network_config {
  file { '/etc/jenkins_jobs/jobs/mirror_network_config.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/mirror_network_config.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

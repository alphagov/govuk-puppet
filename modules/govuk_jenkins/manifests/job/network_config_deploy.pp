# == Class: govuk_jenkins::job::network_config_deploy
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::network_config_deploy {
  file { '/etc/jenkins_jobs/jobs/network_config_deploy.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/network_config_deploy.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

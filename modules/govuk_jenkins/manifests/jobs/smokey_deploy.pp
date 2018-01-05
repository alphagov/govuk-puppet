# == Class: govuk_jenkins::jobs::smokey_deploy
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::smokey_deploy {
  file { '/etc/jenkins_jobs/jobs/smokey_deploy.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/smokey_deploy.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

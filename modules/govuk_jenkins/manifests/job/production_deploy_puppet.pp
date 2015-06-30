# == Class: govuk_jenkins::job::production_deploy_puppet
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::production_deploy_puppet {
  file { '/etc/jenkins_jobs/jobs/production_deploy_puppet.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production_deploy_puppet.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

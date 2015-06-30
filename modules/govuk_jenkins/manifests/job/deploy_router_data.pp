# == Class: govuk_jenkins::job::deploy_router_data
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::deploy_router_data {
  file { '/etc/jenkins_jobs/jobs/deploy_router_data.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_router_data.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

# == Class: govuk_jenkins::job::production_launch_vms
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::production_launch_vms {
  file { '/etc/jenkins_jobs/jobs/production_launch_vms.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production_launch_vms.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

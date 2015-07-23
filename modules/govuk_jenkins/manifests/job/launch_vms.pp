# == Class: govuk_jenkins::job::launch_vms
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::launch_vms (
  $vcloud_org = undef,
  $vcloud_env = undef,
  $vcloud_host = undef,
) {
  file { '/etc/jenkins_jobs/jobs/launch_vms.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/launch_vms.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

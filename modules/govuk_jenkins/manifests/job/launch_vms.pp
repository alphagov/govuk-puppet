# == Class: govuk_jenkins::job::launch_vms
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# [*vcloud_properties*]
#   A hash containing the vCloud organisation name and the environment
#   identifier to launch VMs.
#
class govuk_jenkins::job::launch_vms (
  $vcloud_properties = {},
  $vcloud_host = undef,
) {
  validate_hash($vcloud_properties)

  file { '/etc/jenkins_jobs/jobs/launch_vms.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/launch_vms.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

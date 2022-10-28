# == Class: govuk_jenkins::jobs::vapps
#
# Creates templates for jenkins-job-builder jobs which start and stop vApps.
#
# === Parameters
#
# [*vcloud_properties*]
#   A hash containing details of which vCloud Director instance to operate on. Should include:
#     - username: vCloud Director username
#     - password: vCloud Director password
#     - org: vCloud Director organisation to login to
#     - env: Name of environment in `govuk-provisioning/vcloud-launcher/`
#     - host: Hostname that the vCloud Director API runs on
#
class govuk_jenkins::jobs::vapps (
  $vcloud_properties = {},
  $vcloud_properties_dr = {},
) {
  file { '/etc/jenkins_jobs/jobs/start_vapps.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/start_vapps.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
  file { '/etc/jenkins_jobs/jobs/stop_vapps.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/stop_vapps.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
  file { '/etc/jenkins_jobs/jobs/start_vapps_dr.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/start_vapps_dr.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
  file { '/etc/jenkins_jobs/jobs/stop_vapps_dr.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/stop_vapps_dr.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

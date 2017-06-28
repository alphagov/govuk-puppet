# == Class: govuk_jenkins::job::network_config_deploy
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*environments*]
#   An array of environments where network config can be deployed to. The
#   possibilities are https://github.com/alphagov/govuk-provisioning/blob/master/vcloud-edge_gateway/jenkins.sh
#
class govuk_jenkins::job::network_config_deploy (
  $environments = [],
) {
  file { '/etc/jenkins_jobs/jobs/network_config_deploy.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/network_config_deploy.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

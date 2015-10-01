# == Class: govuk_jenkins::job::network_config_deploy
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*environment_script_parameter*]
#   The environment parameter to pass through to the script that this Jenkins job runs:
#   https://github.gds/gds/govuk-provisioning/blob/master/vcloud-edge_gateway/jenkins.sh
#
class govuk_jenkins::job::network_config_deploy_legacy (
  $environment_script_parameter = '',
) {
  file { '/etc/jenkins_jobs/jobs/network_config_deploy_legacy.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/network_config_deploy_legacy.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

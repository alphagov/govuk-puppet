# == Class: govuk_jenkins::job::network_config_deploy_dryrun
#
# Create a file on disk that can be parsed by staging_network_config_deploy_dryrun
#
class govuk_jenkins::job::network_config_deploy_dryrun {
  file { '/etc/jenkins_jobs/jobs/network_config_deploy_dryrun.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/network_config_deploy_dryrun.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

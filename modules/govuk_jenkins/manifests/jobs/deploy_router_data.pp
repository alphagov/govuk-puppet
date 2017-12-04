# == Class: govuk_jenkins::jobs::deploy_router_data
#
# Create a Jenkins job to deploy router-data
#
# === Parameters
#
# [*rate_limit_token*]
#   A token that can bypass HTTP rate limiting
#
class govuk_jenkins::jobs::deploy_router_data (
  $rate_limit_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/deploy_router_data.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_router_data.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

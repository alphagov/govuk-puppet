# == Class: govuk_jenkins::jobs::whitehall_update_integration_data
#
# === Parameters
#
# [*auth_token*]
#   Token to allow this job to be triggered remotely
#
# [*whitehall_update_integration_data*]
#   Whitehall MySQL password
#
class govuk_jenkins::jobs::whitehall_update_integration_data (
  $auth_token = undef,
  $whitehall_mysql_password,
) {

  $app_domain = hiera('app_domain')

  $service_description = 'Import of Whitehall database from production'
  $job_slug = 'whitehall_update_integration_data'
  $job_url = "https://deploy.${app_domain}/job/${job_slug}"

  file { '/etc/jenkins_jobs/jobs/whitehall_update_integration_data.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/whitehall_update_integration_data.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${job_slug}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 115200,
    action_url          => $job_url,
  }
}

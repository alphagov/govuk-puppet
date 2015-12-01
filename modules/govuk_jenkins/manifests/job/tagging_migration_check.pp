# == Class: govuk_jenkins::job::tagging_migration_check
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::tagging_migration_check (
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'tagging_migration_check'
  $service_description = 'Tagging migration check'
  $job_url = "https://deploy.${app_domain}/job/tagging_migration_check"

  file { '/etc/jenkins_jobs/jobs/tagging_migration_check.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production/tagging_migration_check.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 5400, # 90 minutes
    action_url          => $job_url,
  }
}

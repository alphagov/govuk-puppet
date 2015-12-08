# == Class: govuk_jenkins::job::copy_licensify_data_to_staging
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::copy_licensify_data_to_staging (
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'copy_licensify_data_to_staging'
  $service_description = 'Copy Licensify Data to Staging'
  $job_url = "https://deploy.${app_domain}/job/copy_licensify_data_to_staging"

  file { '/etc/jenkins_jobs/jobs/copy_licensify_data_to_staging.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/copy_licensify_data_to_staging.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 115200,
    action_url          => $job_url,
  }
}

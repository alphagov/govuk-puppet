# == Class: govuk_jenkins::job::local_links_manager_import_service_interactions
#
# Import services and interactions and the mapped service interactions into local-links-manager
#
class govuk_jenkins::job::local_links_manager_import_service_interactions (
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'local-links-manager-import-service-interactions'
  $service_description = 'Import services and interactions into local-links-manager'
  $job_url = "https://deploy.${app_domain}/job/local-links-manager-import-service-interactions/"

  file { '/etc/jenkins_jobs/jobs/local_links_manager_import_service_interactions.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/local_links_manager_import_service_interactions.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => (32 * 24 * 60 * 60), #the job runs monthly on the 1st
    action_url          => $job_url,
  }
}

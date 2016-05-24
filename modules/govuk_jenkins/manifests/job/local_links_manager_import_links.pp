# == Class: govuk_jenkins::job::local_links_manager_import_links
#
# Import links to service interactions for local authorities into local-links-manager
#
class govuk_jenkins::job::local_links_manager_import_links (
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'local-links-manager-import-links'
  $service_description = 'Import links to service interactions for local authorities into local-links-manager'
  $job_url = "https://deploy.${app_domain}/job/local-links-manager-import-links/"

  file { '/etc/jenkins_jobs/jobs/local_links_manager_import_links.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/local_links_manager_import_links.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => (25 * 60 * 60), # 25 hrs (e.g. just over a day)
    action_url          => $job_url,
  }
}

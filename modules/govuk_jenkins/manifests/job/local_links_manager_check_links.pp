# == Class: govuk_jenkins::job::local_links_manager_check_links
#
# Checks the status of links that have been imported into Local Links Manager
#
class govuk_jenkins::job::local_links_manager_check_links (
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'local-links-manager-check-links'
  $service_description = 'Checks the status of links that have been imported into Local Links Manager'
  $job_url = "https://deploy.${app_domain}/job/local-links-manager-check-links/"

  file { '/etc/jenkins_jobs/jobs/local_links_manager_check_links.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/local_links_manager_check_links.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => (25 * 60 * 60), # 25 hrs (e.g. just over a day)
    action_url          => $job_url,
  }
}

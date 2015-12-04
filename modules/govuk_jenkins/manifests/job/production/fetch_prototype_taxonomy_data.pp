# == Class: govuk_jenkins::job::production::fetch-prototype-taxonomy-data
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::production::fetch_prototype_taxonomy_data(
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'fetch-prototype-taxonomy-data'
  $service_description = 'Fetch taxonomy mappings from several google sheets'
  $job_url = "https://deploy.${app_domain}/job/fetch-prototype-taxonomy-data/"

  file { '/etc/jenkins_jobs/jobs/fetch_prototype_taxonomy_data.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production/fetch_prototype_taxonomy_data.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 104400,
    action_url          => $job_url,
  }
}

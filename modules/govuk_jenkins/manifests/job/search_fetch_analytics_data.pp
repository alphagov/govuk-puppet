# == Class: govuk_jenkins::job::search-fetch-analytics-data
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::search_fetch_analytics_data (
  $ga_auth_password = undef,
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'search-fetch-analytics-data'
  $service_description = 'Fetch analytics data for search'
  $job_url = "https://deploy.${app_domain}/job/search-fetch-analytics-data/"

  file { '/etc/jenkins_jobs/jobs/search_fetch_analytics_data.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/search_fetch_analytics_data.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 104400,
    action_url          => $job_url,
    notes_url           => monitoring_docs_url(fetch-analytics-data-for-search-failed),
  }
}

# == Class: govuk_jenkins::jobs::search_api_fetch_analytics_data
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::search_api_fetch_analytics_data (
  $ga_auth_password = undef,
  $skip_page_traffic_load = false,
  $cron_schedule = '5 4 * * *',
) {
  $job_name = 'search-api-fetch-analytics-data'
  $check_name = 'search-api-fetch-analytics-data'
  $service_description = 'Fetch analytics data for Search API'
  $target_application = 'search-api'

  file { '/etc/jenkins_jobs/jobs/search_api_fetch_analytics_data.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/search_fetch_analytics_data.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')
  $job_url = "https://${deploy_jenkins_domain}/job/${job_name}/"

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 104400,
    action_url          => $job_url,
    notes_url           => monitoring_docs_url(fetch-analytics-data-for-search-failed),
  }
}

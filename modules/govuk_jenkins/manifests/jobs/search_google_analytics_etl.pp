# == Class: govuk_jenkins::jobs::search_google_analytics_etl
#
# A Jenkins job to periodically load Google Analytics data into graphite,
# using a rake task in Search API. The data is displayed in the Search Relevancy
# grafana dashboard.
#
# === Parameters:
#
# [*cron_schedule *]
#   The cron schedule to specify how often this task will run
#   Default: undef
#
class govuk_jenkins::jobs::search_google_analytics_etl (
  $cron_schedule = undef,
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'search-google-analytics-etl'
  $service_description = 'Search Google Analytics ETL'
  $job_url = "https://deploy.${::aws_environment}.govuk.digital/job/search_google_analytics_etl/"

  file { '/etc/jenkins_jobs/jobs/search_google_analytics_etl.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/search_google_analytics_etl.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  if $cron_schedule {
    @@icinga::passive_check { "${check_name}_${::hostname}":
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => 86400,
      action_url          => $job_url,
      contact_groups      => ['slack-channel-search-team'],
    }
  }
}

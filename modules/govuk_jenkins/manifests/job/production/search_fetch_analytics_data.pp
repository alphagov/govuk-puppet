# == Class: govuk_jenkins::job::production::search-fetch-analytics-data
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::production::search_fetch_analytics_data (
  $ga_auth_password = undef,
) {
  file { '/etc/jenkins_jobs/jobs/search_fetch_analytics_data.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production/search_fetch_analytics_data.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

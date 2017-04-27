# == Class: govuk_jenkins::job::search_test_spelling_suggestions
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::search_test_spelling_suggestions (
  $app_domain = hiera('app_domain'),
  $auth_username = undef,
  $auth_password = undef
) {

  $test_type = 'suggestions'
  $job_name = 'search_test_spelling_suggestions'
  $service_description = 'Check for spelling suggestions (see https://docs.google.com/spreadsheets/d/1JjSoy68vscNjrvQm8b9hHt0nbZgFxk8lrcTdqV08iHk)'
  $job_url = "https://deploy.${app_domain}/job/search_test_spelling_suggestions/"
  $cron_schedule = '0 5 * * *'

  $slack_team_domain = 'govuk'
  $slack_room = 'search-team'
  $slack_build_server_url = "https://deploy.${app_domain}/"

  file { '/etc/jenkins_jobs/jobs/search_test_spelling.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/benchmark_search.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${job_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 104400,
    action_url          => $job_url,
    notes_url           => monitoring_docs_url(search-healthcheck),
  }
}

# == Class: govuk_jenkins::jobs::search_relevancy_rank_evaluation
#
# A Jenkins job to periodically run search_relevancy_rank_evaluation.
# This monitoring job sends the results of a rake task to graphite.
#
# === Parameters:
#
# [*cron_schedule *]
#   The cron schedule to specify how often this task will run
#   Default: undef
#
class govuk_jenkins::jobs::search_relevancy_rank_evaluation (
  $cron_schedule = undef,
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'search-relevancy-rank-evaluation'
  $service_description = 'Search Relevancy Rank Evaluation'
  $job_url = "https://deploy.${::aws_environment}.govuk.digital/job/search_relevancy_rank_evaluation/"

  file { '/etc/jenkins_jobs/jobs/search_relevancy_rank_evaluation.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/search_relevancy_rank_evaluation.yaml.erb'),
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

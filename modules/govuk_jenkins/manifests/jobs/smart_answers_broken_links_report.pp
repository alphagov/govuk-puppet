# == Class: govuk_jenkins::jobs::smart_answers_broken_links_report
#
# A Jenkins job to periodically run smart_answers_broken_links_report.
# This monitoring job sends the results of a rake task to graphite.
#
# === Parameters:
#
# [*cron_schedule *]
#   The cron schedule to specify how often this task will run
#   Default: undef
#
class govuk_jenkins::jobs::smart_answers_broken_links_report (
  $cron_schedule = undef,
  $app_domain = hiera('app_domain'),
) {
  $check_name = 'smart-answers-broken-links-report'
  $service_description = 'Smart Answers Broken Links Report'
  $job_url = "https://deploy.blue.${::aws_environment}.govuk.digital/job/smart_answers_broken_links_report/"

  file { '/etc/jenkins_jobs/jobs/smart_answers_broken_links_report.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/smart_answers_broken_links_report.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  if $cron_schedule {
    @@icinga::passive_check { "${check_name}_${::hostname}":
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => 86400,
      action_url          => $job_url,
    }
  }
}

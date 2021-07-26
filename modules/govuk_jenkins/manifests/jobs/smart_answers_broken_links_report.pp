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
) {
  $check_name = 'smart-answers-broken-links-report'
  $service_description = 'Smart Answers Broken Links Report'
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')
  $job_url = "https://${deploy_jenkins_domain}/job/smart_answers_broken_links_report/"

  file { '/etc/jenkins_jobs/jobs/smart_answers_broken_links_report.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/smart_answers_broken_links_report.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  if $cron_schedule {
    @@icinga::passive_check { "${check_name}_${::hostname}":
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => 1468800, # every 17 days
      action_url          => $job_url,
    }
  }
}

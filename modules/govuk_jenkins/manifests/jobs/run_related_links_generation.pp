# == Class: govuk_jenkins::jobs::run_related_links_generation
#
# Manages the orchestration of the related links generation process.
#
# === Parameters:
#
# [*cron_schedule *]
#   The cron schedule to specify how often this task will run
#   Default: undef
#
class govuk_jenkins::jobs::run_related_links_generation (
  $cron_schedule = undef,
) {
  file { '/etc/jenkins_jobs/jobs/run_related_links_generation.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/run_related_links_generation.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

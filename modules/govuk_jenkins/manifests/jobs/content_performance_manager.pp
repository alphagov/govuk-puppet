# == Class: govuk_jenkins::jobs::content_performance_manager
#
# Create a jenkins job to periodically run rake for the following tasks:
# - import:all_content_items
#
# === Parameters:
#
# [*rake_etl_master_process_cron_schedule *]
#   The cron timings for the etl:master process
#   Default: undef
#
class govuk_jenkins::jobs::content_performance_manager (
  $rake_etl_master_process_cron_schedule = undef,
) {
  file { '/etc/jenkins_jobs/jobs/content_performance_manager.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/content_performance_manager.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

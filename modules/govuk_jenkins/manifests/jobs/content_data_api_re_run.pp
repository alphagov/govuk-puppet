# == Class: govuk_jenkins::jobs::content_data_api_re_run
#
# Create a jenkins job to periodically run rake for the following tasks:
# - rake etl:rerun_master
#
# === Parameters:
#
# [*re_run_rake_etl_master_process_cron_schedule *]
#   The cron timings for the etl:master process
#   Default: undef
#
class govuk_jenkins::jobs::content_data_api_re_run (
  $re_run_rake_etl_master_process_cron_schedule,
  $app_domain = hiera('app_domain'),
) {

  file { '/etc/jenkins_jobs/jobs/content_data_api_re_run.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/content_data_api_re_run.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

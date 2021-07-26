# == Class: govuk_jenkins::jobs::content_data_api_re_run
#
# Create a jenkins job to periodically run rake for the following tasks:
# - etl:rerun_main
#
# === Parameters:
#
# [*re_run_rake_etl_main_process_cron_schedule *]
#   The cron timings for the etl:main process
#   Default: undef
#
class govuk_jenkins::jobs::content_data_api_re_run (
  $re_run_rake_etl_main_process_cron_schedule,
) {

  file { '/etc/jenkins_jobs/jobs/content_data_api_re_run.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/content_data_api_re_run.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

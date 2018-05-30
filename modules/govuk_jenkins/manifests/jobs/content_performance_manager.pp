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
  $app_domain = hiera('app_domain'),
) {
  file { '/etc/jenkins_jobs/jobs/content_performance_manager.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/content_performance_manager.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  $check_name = 'etl-data-warehouse'
  $service_description = 'Data warehouse ETL'
  $job_url = "https://deploy.${app_domain}/job/content_performance_manager_import_etl_master_process/"

  if $rake_etl_master_process_cron_schedule {
    @@icinga::passive_check { "${check_name}_${::hostname}":
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => 104400,
      action_url          => $job_url,
      notes_url           => monitoring_docs_url(data-warehouse-etl-failed),
    }
  }
}

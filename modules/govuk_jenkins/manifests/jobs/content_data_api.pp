# == Class: govuk_jenkins::jobs::content_data_api
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
class govuk_jenkins::jobs::content_data_api (
  $rake_etl_master_process_cron_schedule = undef,
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'etl-content-data-api'
  $service_description = 'Content Data API ETL [Extract - transform - load]'
  $job_url = "https://deploy.${::aws_environment}.govuk.digital/job/content_data_api_import_etl_master_process/"

  file { '/etc/jenkins_jobs/jobs/content_data_api.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/content_data_api.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  if $rake_etl_master_process_cron_schedule {
    @@icinga::passive_check { "${check_name}_${::hostname}":
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => 104400,
      action_url          => $job_url,
      contact_groups      => ['slack-channel-data-informed'],
    }
  }
}

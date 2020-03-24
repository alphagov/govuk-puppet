# == Class: govuk_jenkins::jobs::data_sync_complete_staging
#
# Create a Jenkins job that is triggered when the data sync from production finishes.
# This is specific to the Staging environment.
#
# === Parameters
#
# [*auth_token*]
#   Token to allow this job to be triggered remotely
#
# [*signon_domains_to_migrate*]
#   An array of hashes containing `old` (the existing Signon domain) and `new`,
#   (what that domain should be changed to when synced).
#
class govuk_jenkins::jobs::data_sync_complete_staging (
  $auth_token = undef,
  $signon_domains_to_migrate = [],
) {
  if $::aws_migration {
    $aws = true

    $job_url = "https://deploy.blue.${::aws_environment}.govuk.digital/job/Data_Sync_Complete"
  } else {
    $aws = false

    $job_url = "https://deploy.${::app_domain}/job/Data_Sync_Complete"
  }

  $check_name = 'data_sync_complete'
  $service_description = 'Data Sync Complete'

  file { '/etc/jenkins_jobs/jobs/data_sync_complete.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/data_sync_complete_staging.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 115200,
    action_url          => $job_url,
    notes_url           => monitoring_docs_url(data-sync),
  }
}

# == Class: govuk_jenkins::jobs::ask_export
#
# This job exports responses from the Ask service so that they can be used by the relevant departments
#
#
class govuk_jenkins::jobs::ask_export (
  $smart_survey_api_token = undef,
  $smart_survey_api_token_secret = undef,
  $smart_survey_config = undef,
  $google_client_id = undef,
  $google_client_email = undef,
  $google_private_key = undef,
  $folder_id_cabinet_office = undef,
  $folder_id_third_party = undef,
  $aws_region = undef,
  $aws_access_key = undef,
  $aws_secret_access_key = undef,
  $s3_bucket_name_gcs_public_questions = undef,
  $run_daily = undef,
) {

  $service_description = 'Ask Service data export'
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')

  file { '/etc/jenkins_jobs/jobs/ask_export.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/ask_export.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'];
  }

  if $run_daily {
    @@icinga::passive_check { "ask_export_${::hostname}":
        ensure              => present,
        service_description => $service_description,
        host_name           => $::fqdn,
        freshness_threshold => 86400, # 24 Hours
        action_url          => "https://${deploy_jenkins_domain}/job/ask-export/",
        # notes_url           => monitoring_docs_url(ask-export);
    }
  }
}

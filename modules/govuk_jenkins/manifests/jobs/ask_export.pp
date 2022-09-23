# == Class: govuk_jenkins::jobs::ask_export
#
# This job exports responses from the Ask service so that they can be used by the relevant departments
#
#
# === Parameters
#
# [*smart_survey_api_token*]
#   API token for accessing Smart Survey
#
# [*smart_survey_api_token_secret*]
#   API token secret for accessing Smart Survey
#
# [*smart_survey_config*]
#   A flag for the state of the Smart Survey, either draft or live depending on environment
#
# [*google_client_id*]
#   Client id for the Google drive this exports to
#
# [*google_client_email*]
#   Email address of the service account that the Google export folders belong to
#
# [*google_private_key*]
#   Private key needed to access the Google service account
#
# [*folder_id_cabinet_office*]
#   ID of the folder for Cabinet Office export
#
# [*folder_id_third_party*]
#   ID of the folder for third party export
#
# [*run_daily*]
#   A flag to decide whether the job runs every day or not
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
  $run_daily = false,
) {

  $service_description = 'Ask Service data export'
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')

  file { '/etc/jenkins_jobs/jobs/ask_export.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/ask_export.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'];
  }

  $freshness_threshold = $run_daily ? {
    true  => 86400, # 24 hours
    false => '',
  }

  @@icinga::passive_check { "ask_export_${::hostname}":
      ensure              => present,
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => $freshness_threshold,
      action_url          => "https://${deploy_jenkins_domain}/job/govuk-ask-export/",
      notes_url           => monitoring_docs_url(ask-export),
  }
}

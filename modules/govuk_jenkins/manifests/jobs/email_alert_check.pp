# == Class: govuk_jenkins::jobs::email_alert_check
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*google_oauth_credentials*]
#   JSON blob with oauth credentials with access to the googleapi@ email account.
#
# [*google_client_id*]
#   Google app client ID.
#
# [*google_client_secret*]
#   Google app client secret.
#
# [*emails_that_should_receive_drug_alerts*]
#   Email addresses subscribed to drug alerts.
#
# [*emails_that_should_receive_travel_advice_alerts*]
#   Email addresses subscribed to travel advice alerts.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
class govuk_jenkins::jobs::email_alert_check (
  $google_oauth_credentials = undef,
  $google_client_id = undef,
  $google_client_secret = undef,
  $emails_that_should_receive_drug_alerts = undef,
  $emails_that_should_receive_travel_advice_alerts = undef,
  $app_domain = hiera('app_domain'),
  $sentry_dsn = undef,
) {

  $drug_check_name = 'email_alert_check'
  $drug_service_description = 'Email alert check'
  $drug_job_url = "https://deploy.${app_domain}/job/email-alert-check/"
  $travel_advice_check_name = 'travel_advice_email_alert_check'
  $travel_advice_service_description = 'Travel Advice email alert check'
  $travel_advice_job_url = "https://deploy.${app_domain}/job/travel-advice-email-alert-check/"

  file {
    '/etc/jenkins_jobs/jobs/drug_email_alert_check.yaml':
      ensure  => present,
      content => template('govuk_jenkins/jobs/drug_email_alert_check.yaml.erb'),
      notify  => Exec['jenkins_jobs_update'];
    '/etc/jenkins_jobs/jobs/travel_advice_email_alert_check.yaml':
      ensure  => present,
      content => template('govuk_jenkins/jobs/travel_advice_email_alert_check.yaml.erb'),
      notify  => Exec['jenkins_jobs_update'];
  }

  @@icinga::passive_check {
    "${drug_check_name}_${::hostname}":
      service_description => $drug_service_description,
      host_name           => $::fqdn,
      freshness_threshold => 5400, # 90 minutes
      action_url          => $drug_job_url,
      notes_url           => monitoring_docs_url(email-alerts);
    "${travel_advice_check_name}_${::hostname}":
      service_template    => 'govuk_urgent_priority',
      service_description => $travel_advice_service_description,
      host_name           => $::fqdn,
      freshness_threshold => 5400, # 90 minutes
      action_url          => $travel_advice_job_url,
      notes_url           => monitoring_docs_url(email-alerts);

  }
}

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
# [*email_addresses_to_check*]
#   Email addresses to check.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
class govuk_jenkins::jobs::email_alert_check (
  $google_oauth_credentials = undef,
  $google_client_id = undef,
  $google_client_secret = undef,
  $email_addresses_to_check = undef,
  $app_domain = hiera('app_domain'),
  $sentry_dsn = undef,
) {

  $medical_safety_check_name = 'medical_safety_email_alert_check'
  $medical_safety_service_description = 'Medical Safety Email alert check'
  $medical_safety_job_url = "https://deploy.blue.${::aws_environment}.govuk.digital/job/medical-safety-email-alert-check/"
  $travel_advice_check_name = 'travel_advice_email_alert_check'
  $travel_advice_service_description = 'Travel Advice email alert check'
  $travel_advice_job_url = "https://deploy.blue.${::aws_environment}.govuk.digital/job/travel-advice-email-alert-check/"

  file {
    '/etc/jenkins_jobs/jobs/medical_safety_email_alert_check.yaml':
      ensure  => present,
      content => template('govuk_jenkins/jobs/medical_safety_email_alert_check.yaml.erb'),
      notify  => Exec['jenkins_jobs_update'];
    '/etc/jenkins_jobs/jobs/travel_advice_email_alert_check.yaml':
      ensure  => present,
      content => template('govuk_jenkins/jobs/travel_advice_email_alert_check.yaml.erb'),
      notify  => Exec['jenkins_jobs_update'];
  }

  @@icinga::passive_check {
    "${medical_safety_check_name}_${::hostname}":
      service_description     => $medical_safety_service_description,
      host_name               => $::fqdn,
      freshness_threshold     => 5400, # 90 minutes
      freshness_alert_level   => 'critical',
      freshness_alert_message => 'Jenkins job has stopped running or is unstable',
      action_url              => $medical_safety_job_url,
      notes_url               => monitoring_docs_url(email-alerts);
    "${travel_advice_check_name}_${::hostname}":
      service_template        => 'govuk_urgent_priority',
      service_description     => $travel_advice_service_description,
      host_name               => $::fqdn,
      freshness_threshold     => 5400, # 90 minutes
      freshness_alert_level   => 'critical',
      freshness_alert_message => 'Jenkins job has stopped running or is unstable',
      action_url              => $travel_advice_job_url,
      notes_url               => monitoring_docs_url(email-alerts);

  }
}

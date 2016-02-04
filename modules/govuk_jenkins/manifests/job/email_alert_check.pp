# == Class: govuk_jenkins::job::email_alert_check
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
class govuk_jenkins::job::email_alert_check (
  $google_oauth_credentials = undef,
  $google_client_id = undef,
  $google_client_secret = undef,
  $emails_that_should_receive_drug_alerts = undef,
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'email_alert_check'
  $service_description = 'Email alert check'
  $job_url = "https://deploy.${app_domain}/job/email-alert-check/"

  file { '/etc/jenkins_jobs/jobs/email_alert_check.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/email_alert_check.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 5400, # 90 minutes
    action_url          => $job_url,
    notes_url           => monitoring_docs_url(email-alerts),
  }
}

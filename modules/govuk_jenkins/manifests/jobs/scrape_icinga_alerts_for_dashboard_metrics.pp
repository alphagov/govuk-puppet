# == Class: govuk_jenkins::jobs::scrape_icinga_alerts_for_dashboard_metrics
#
#This is run monthly to call a script that scrapes hard alerts from Icinga, and stored in a Google sheet.
#The data is used by the Platform Health dashboard to display metrics about our apps.
#
# === Parameters
#
# [*private_key_id*]
#   Specific to access the Google API.
#
# [*private_key*]
#   Specific to access the Google API.
#
# [*client_email*]
#   Specific to access the Google API.
#
# [*client_id*]
#   Specific to access the Google API.
#
# [*client_x509_cert_url*]
#   Specific to access the Google API.
#
# [*run_monthly*]
#   Set to true if the job should run by itself every month.
#
class govuk_jenkins::jobs::scrape_icinga_alerts_for_dashboard_metrics (
  $project_id = 'gam-project-v3f-sr7-n9p',
  $private_key_id = undef,
  $private_key = undef,
  $client_email = undef,
  $client_id = undef,
  $client_x509_cert_url = undef,
  $enable_slack_notifications = true,
  $slack_auth_token = undef,
  $run_monthly = false,
  $app_domain = hiera('app_domain'),
) {

  $slack_team_domain = 'gds'
  $slack_room = 'platform-health'
  $slack_build_server_url = "https://deploy.${app_domain}/"

  file { '/var/lib/jenkins/workspace/scrape_icinga_alerts_for_dashboard_metrics/':
    ensure => directory,
    owner  => 'jenkins',
    group  => 'jenkins',
  }

  file { '/var/lib/jenkins/workspace/scrape_icinga_alerts_for_dashboard_metrics/credentials.json':
    ensure  => present,
    content => template('govuk_jenkins/google_api/credentials.json.erb'),
    owner   => 'jenkins',
    group   => 'jenkins',
  }

  file { '/etc/jenkins_jobs/jobs/scrape_icinga_alerts_for_dashboard_metrics.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/scrape_icinga_alerts_for_dashboard_metrics.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

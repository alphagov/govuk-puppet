# == Class: govuk_jenkins::jobs::publishing_api_archive_events
#
# Create a jenkins job to periodically archive publishing API events
#
#
# === Parameters:
#
class govuk_jenkins::jobs::publishing_api_archive_events {
  $check_name = 'publishing_api_archive_events'
  $service_description = 'Periodically archive publishing-api events to S3'
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')
  $job_url = "https://${deploy_jenkins_domain}/job/Publishing_API_Archive_Events/"

  file { '/etc/jenkins_jobs/jobs/publishing_api_archive_events.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/publishing_api_archive_events.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => (1 + (7 * 24)) * 60 * 60, # one week plus 1 hour
    action_url          => $job_url,
  }
}

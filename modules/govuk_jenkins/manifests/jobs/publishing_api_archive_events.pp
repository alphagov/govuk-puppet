# == Class: govuk_jenkins::jobs::publishing_api_archive_events
#
# Create a jenkins job to periodically archive publishing API events
#
#
# === Parameters:
#
class govuk_jenkins::jobs::publishing_api_archive_events(
  $app_domain = hiera('app_domain'),
) {
  file { '/etc/jenkins_jobs/jobs/publishing_api_archive_events.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/publishing_api_archive_events.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  $check_name = 'publishing_api_archive_events'
  $service_description = 'Periodically archive publishing-api events to S3'
  $job_url = "https://deploy.${app_domain}/job/Publishing_API_Archive_Events/"

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 104400,
    action_url          => $job_url,
  }
}

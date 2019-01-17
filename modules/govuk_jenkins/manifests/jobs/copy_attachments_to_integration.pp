# == Class: govuk_jenkins::jobs::copy_attachments_to_integration
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::copy_attachments_to_integration (
  $app_domain = hiera('app_domain'),
  $enable_slack_notifications = true,
) {

  $check_name = 'copy_attachments_to_integration'
  $environment_variables = $govuk_jenkins::environment_variables
  $service_description = 'Copy Attachments to Integration'
  $job_url = "https://deploy.${app_domain}/job/copy_attachments_to_integration"

  $slack_team_domain = 'gds'
  $slack_room = 'govuk-2ndline'
  $slack_build_server_url = "https://deploy.${app_domain}/"

  file { '/etc/jenkins_jobs/jobs/copy_attachments_to_integration.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/copy_attachments_to_integration.yaml.erb'),
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

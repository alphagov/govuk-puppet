# == Class: govuk_jenkins::jobs::copy_data_to_staging
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::copy_data_to_staging (
  $mysql_src_root_pw = undef,
  $mysql_dst_root_pw = undef,
  $pg_src_env_sync_pw = undef,
  $pg_dst_env_sync_pw = undef,
  $jenkins_api_user_password = undef,
  $enable_slack_notifications = true,
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'copy_data_to_staging'
  $service_description = 'Copy Data to Staging'
  $job_url = "https://deploy.${app_domain}/job/copy_data_to_staging/"

  $slack_team_domain = 'gds'
  $slack_room = 'govuk-2ndline'
  $slack_build_server_url = "https://deploy.${app_domain}/"

  file { '/etc/jenkins_jobs/jobs/copy_data_to_staging.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/copy_data_to_staging.yaml.erb'),
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

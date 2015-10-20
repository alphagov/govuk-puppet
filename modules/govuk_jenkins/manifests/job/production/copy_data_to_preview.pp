# == Class: govuk_jenkins::job::production::copy_data_to_preview
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::production::copy_data_to_preview (
  $mysql_src_root_pw = undef,
  $mysql_dst_root_pw = undef,
  $pg_src_env_sync_pw = undef,
  $pg_dst_env_sync_pw = undef,
  $ci_alphagov_api_key = undef,
  $ci_alphagov_api_token = undef,
  $app_domain = hiera('app_domain'),
) {
  file { '/etc/jenkins_jobs/jobs/copy_data_to_preview.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production/copy_data_to_preview.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  $check_name = 'copy_data_to_preview'
  $service_description = 'Copy Data to Preview'
  $job_url = "https://deploy.${app_domain}/job/copy_data_to_preview"

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 115200,
    action_url          => $job_url,
  }
}

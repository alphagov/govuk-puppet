# == Class: govuk_jenkins::job::production::copy_data_to_staging
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::production::copy_data_to_staging (
  $mysql_src_root_pw = undef,
  $mysql_dst_root_pw = undef,
  $pg_src_env_sync_pw = undef,
  $pg_dst_env_sync_pw = undef,
  $ci_alphagov_api_key = undef,
  $ci_alphagov_api_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/copy_data_to_staging.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production/copy_data_to_staging.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

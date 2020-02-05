# == Class: govuk_jenkins::jobs::athena_fastly_logs_check
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*aws_access_key_id*]
#   Access key id for user who can read from Athena and write to the bucket
#
# [*aws_secret_access_key*]
#   Secret access key for the above user
#
# [*aws_region*]
#   The region athena is running in
#
# [*databases*]
#   An array of fastly logs databases to check for results
#
# [*s3_results_bucket*]
#   An S3 bucket where the query results can be written too
#
class govuk_jenkins::jobs::athena_fastly_logs_check (
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_region = 'eu-west-1',
  $databases = ['govuk_www', 'govuk_assets'],
  $s3_results_bucket = undef,
) {
  if $::aws_migration and ($::aws_environment != 'integration') {
    $hosting_env_domain = "blue.${::aws_environment}.govuk.digital"
  }
  else {
    $hosting_env_domain = hiera('app_domain')
  }

  $jenkins_url = "https://deploy.${hosting_env_domain}/job/athena-fastly-logs-check/"
  $jenkins_service_description = "Athena has recent results for fasty_logs \${DATABASE}"

  file {
    '/etc/jenkins_jobs/jobs/athena_fastly_logs_check.yaml':
      ensure  => present,
      content => template('govuk_jenkins/jobs/athena_fastly_logs_check.yaml.erb'),
      notify  => Exec['jenkins_jobs_update'];
  }

  govuk_jenkins::jobs::athena_fastly_logs_check::icinga_database_check {
    $databases:
      jenkins_url         => $jenkins_url,
      service_description => $jenkins_service_description,
  }
}

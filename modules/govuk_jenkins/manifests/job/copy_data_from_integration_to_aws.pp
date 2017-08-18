# == Class: govuk_jenkins::job::copy_data_from_integration_to_aws
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::copy_data_from_integration_to_aws (
  $whitehall_mysql_password = undef,
  $app_domain = hiera('app_domain'),
) {
  $slack_team_domain = 'govuk'
  $slack_room = '2ndline'
  $slack_build_server_url = "https://deploy.${app_domain}/"

  file { '/etc/jenkins_jobs/jobs/copy_data_from_integration_to_aws.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/copy_data_from_integration_to_aws.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

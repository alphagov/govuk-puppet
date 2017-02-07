# == Class: govuk_jenkins::job::run_smokey_after_deploy
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*auth_username*]
#   HTTP basic auth username
#
# [*auth_password*]
#   HTTP basic auth password
#
# [*efg_username*]
#   Username to sign in to EFG
#
# [*efg_password*]
#   Password to sign in to EFG
#
# [*signon_email*]
#   Username to sign in to Signon
#
# [*signon_password*]
#   Password to sign in to Signon
#
# [*smokey_bearer_token*]
#   Bearer token to pass as part of an Authorization HTTP header
#
# [*smokey_rate_limit_token*]
#   Token to pass as an HTTP header to bypass rate limiting
#
# [*smokey_task*]
#   The rake task to run for the tests
#
class govuk_jenkins::job::run_smokey_after_deploy (
  $auth_username = undef,
  $auth_password = undef,
  $efg_username = undef,
  $efg_password = undef,
  $signon_email = undef,
  $signon_password = undef,
  $smokey_bearer_token = undef,
  $smokey_rate_limit_token = undef,
  $smokey_task = 'test:production',
  $app_domain = hiera('app_domain')
) {
  $slack_team_domain = 'govuk'
  $slack_room = '2ndline'
  $slack_build_server_url = "https://deploy.${app_domain}/"

  file { '/etc/jenkins_jobs/jobs/run_smokey_after_deploy.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/run_smokey_after_deploy.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

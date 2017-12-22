# == Class: govuk_jenkins::job::smokey
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*smokey_task*]
#   The rake task to run for the tests
#
class govuk_jenkins::job::smokey (
  $smokey_task = 'test:production',
) {
  $app_domain = hiera('app_domain')

  $slack_team_domain = 'govuk'
  $slack_room = '2ndline'
  $slack_build_server_url = "https://deploy.${app_domain}/"

  include govuk::apps::smokey

  file { '/etc/jenkins_jobs/jobs/smokey.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/smokey.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
    require => Class['govuk::apps::smokey'],
  }
}

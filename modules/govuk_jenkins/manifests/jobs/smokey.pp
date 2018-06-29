# == Class: govuk_jenkins::jobs::smokey
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*enable_slack_notifications*]
#   Whether slack should be notified about this job
#
# [*environment*]
#   The environment which is running Smokey. Used to build the rake task.
#
class govuk_jenkins::jobs::smokey (
  $enable_slack_notifications = false,
  $environment = 'production',
) {
  $smokey_task = "test:${environment}"
  $app_domain = hiera('app_domain')

  $slack_team_domain = 'gds'
  $slack_room = 'govuk-2ndline'
  $slack_build_server_url = "https://deploy.${app_domain}/"

  include govuk::apps::smokey

  file { '/etc/jenkins_jobs/jobs/smokey.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/smokey.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
    require => Class['govuk::apps::smokey'],
  }
}

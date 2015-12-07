# == Class:
# govuk_jenkins::job::govuk_delivery_configure_integration_catchall_feed
#
# === Parameters
#
# [*auth_token*]
#   Token to allow this job to be triggered remotely
#
class govuk_jenkins::job::govuk_delivery_configure_integration_catchall_feed (
  $auth_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/govuk_delivery_configure_integration_catchall_feed.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/integration/govuk_delivery_configure_integration_catchall_feed.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

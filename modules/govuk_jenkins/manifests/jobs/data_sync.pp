# == Class: govuk_jenkins::jobs::data-sync
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::data_sync(
  $enable_slack_notifications = false,
) {

  file { '/etc/jenkins_jobs/jobs/data_sync.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/data_sync.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

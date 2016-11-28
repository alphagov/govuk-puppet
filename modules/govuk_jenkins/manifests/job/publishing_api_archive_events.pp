# == Class: govuk_jenkins::job::publishing_api_archive_events
#
# Create a jenkins job to periodically archive publishing API events
#
#
# === Parameters:
#
class govuk_jenkins::job::publishing_api_archive_events {
  file { '/etc/jenkins_jobs/jobs/publishing_api_archive_events.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/publishing_api_archive_events.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

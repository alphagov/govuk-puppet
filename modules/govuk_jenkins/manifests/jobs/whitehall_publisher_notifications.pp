# == Class: govuk_jenkins::jobs::whitehall_publisher_notifications
#
# Create a jenkins job to periodically send whitehall publisher notifications
# via the rake task `publisher_notifications:send`.
#
class govuk_jenkins::jobs::whitehall_publisher_notifications {
  file { '/etc/jenkins_jobs/jobs/whitehall_publisher_notifications.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/whitehall_publisher_notifications.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

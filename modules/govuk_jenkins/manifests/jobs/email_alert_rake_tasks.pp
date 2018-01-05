# == Class: govuk_jenkins::jobs::email_alert_rake_tasks
#
# Create a Jenkins job
#
class govuk_jenkins::jobs::email_alert_rake_tasks  {
  file { '/etc/jenkins_jobs/jobs/email_alert_rake_tasks.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/email_alert_rake_tasks.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

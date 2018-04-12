# == Class: govuk_jenkins::jobs::send_bulk_email
#
# Send a bulk email to a number of subscriber lists.
#
class govuk_jenkins::jobs::send_bulk_email {

  file { '/etc/jenkins_jobs/jobs/send_bulk_email.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/send_bulk_email.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

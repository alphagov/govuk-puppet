# == Class: govuk_jenkins::jobs::publication_delay_report
#
# Run a publication delay report showing delays in publications over the last week.
#
class govuk_jenkins::jobs::publication_delay_report {
  file { '/etc/jenkins_jobs/jobs/publication_delay_report.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/publication_delay_report.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

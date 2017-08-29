# == Class: govuk_jenkins::job::passive_checks
#
# Create two files on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::passive_checks (
  $alert_hostname = 'alert.cluster',
) {
  file { '/etc/jenkins_jobs/jobs/success_passive_check.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/success_passive_check.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  file { '/etc/jenkins_jobs/jobs/failure_passive_check.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/failure_passive_check.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

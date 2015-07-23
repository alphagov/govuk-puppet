# == Class: govuk_jenkins::job::production::whitehall_run_broken_link_checker
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::production::whitehall_run_broken_link_checker {
  file { '/etc/jenkins_jobs/jobs/whitehall_run_broken_link_checker.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production/whitehall_run_broken_link_checker.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

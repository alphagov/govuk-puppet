# == Class: govuk_jenkins::jobs::run_rake_task
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::run_rake_task(
  $applications = undef,
) {

  file { '/etc/jenkins_jobs/jobs/run_rake_task.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/run_rake_task.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

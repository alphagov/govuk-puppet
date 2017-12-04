# == Class: govuk_jenkins::jobs::run_whitehall_data_migrations
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::run_whitehall_data_migrations {
  file { '/etc/jenkins_jobs/jobs/run_whitehall_data_migrations.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/run_whitehall_data_migrations.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

# == Class: govuk_jenkins::jobs::copy_sanitised_whitehall_database
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::copy_sanitised_whitehall_database (
  $whitehall_mysql_password = undef,
) {
  file { '/etc/jenkins_jobs/jobs/copy_sanitised_whitehall_database.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/copy_sanitised_whitehall_database.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

# == Class: govuk_jenkins::job::copy_whitehall_data_to_integration
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::copy_whitehall_data_to_integration (
  $whitehall_mysql_password = undef,
) {
  file { '/etc/jenkins_jobs/jobs/copy_whitehall_data_to_integration.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/copy_whitehall_data_to_integration.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

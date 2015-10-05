# == Class: govuk_jenkins::job::production::copy_whitehall_db_to_preview
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::production::copy_whitehall_db_to_preview (
  $whitehall_mysql_password = undef,
) {
  file { '/etc/jenkins_jobs/jobs/copy_whitehall_db_to_preview.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production/copy_whitehall_db_to_preview.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

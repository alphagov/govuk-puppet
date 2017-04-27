# == Class: govuk_jenkins::job::check_content_consistency
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::check_content_consistency {
  file { '/etc/jenkins_jobs/jobs/check_content_consistency.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/check_content_consistency.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

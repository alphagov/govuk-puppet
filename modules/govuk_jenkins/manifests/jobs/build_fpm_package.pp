# == Class: govuk_jenkins::jobs::build_fpm_package
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::build_fpm_package {
  file { '/etc/jenkins_jobs/jobs/build_fpm_package.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/build_fpm_package.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

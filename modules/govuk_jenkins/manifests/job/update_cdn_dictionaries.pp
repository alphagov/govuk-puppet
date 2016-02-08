# == Class: govuk_jenkins::job::update_cdn_dictionaries
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::update_cdn_dictionaries {
  file { '/etc/jenkins_jobs/jobs/update_cdn_dictionaries.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/update_cdn_dictionaries.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

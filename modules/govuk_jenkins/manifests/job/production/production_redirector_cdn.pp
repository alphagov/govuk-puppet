# == Class: govuk_jenkins::job::production::production_redirector_cdn
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::production::production_redirector_cdn {
  file { '/etc/jenkins_jobs/jobs/production_redirector_cdn.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production/production_redirector_cdn.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

# == Class: govuk_jenkins::job::validate_published_dns
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::validate_published_dns {
  file { '/etc/jenkins_jobs/jobs/validate_published_dns.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/validate_published_dns.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

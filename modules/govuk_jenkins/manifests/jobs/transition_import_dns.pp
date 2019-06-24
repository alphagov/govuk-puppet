# == Class: govuk_jenkins::jobs::transition_import_dns
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::transition_import_dns {
  file { '/etc/jenkins_jobs/jobs/transition_import_dns.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/transition_import_dns.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

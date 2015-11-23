# == Class: govuk_jenkins::job::production::production_redirector_cdn
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# FIXME: remove after this has been deployed to Production
class govuk_jenkins::job::production::production_redirector_cdn () {
  file { '/etc/jenkins_jobs/jobs/production_redirector_cdn.yaml':
    ensure => absent,
    notify => Exec['jenkins_jobs_update'],
  }
}

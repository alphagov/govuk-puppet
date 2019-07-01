# == Class: govuk_jenkins::jobs::bouncer_cdn_redirect
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::bouncer_cdn_redirect {

  file { '/etc/jenkins_jobs/jobs/bouncer_cdn.yaml':
    ensure => absent,
    notify => Exec['jenkins_jobs_update'],
  }

}

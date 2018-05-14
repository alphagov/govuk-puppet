# == Class: govuk_jenkins::jobs::clear_frontend_memcache
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::clear_frontend_memcache {
  file { '/etc/jenkins_jobs/jobs/clear_frontend_memcache.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/clear_frontend_memcache.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

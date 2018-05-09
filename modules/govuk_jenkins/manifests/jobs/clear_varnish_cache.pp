# == Class: govuk_jenkins::jobs::clear_varnish_cache
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::clear_varnish_cache {
  file { '/etc/jenkins_jobs/jobs/clear_varnish_cache.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/clear_varnish_cache.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

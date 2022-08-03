# == Class: govuk_jenkins::jobs::clear_cdn_cache
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::clear_cdn_cache(
  $fastly_api_token = undef,
  $website_root_url = nil,
) {
  file { '/etc/jenkins_jobs/jobs/clear_cdn_cache.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/clear_cdn_cache.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

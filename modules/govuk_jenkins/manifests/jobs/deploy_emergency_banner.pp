# == Class: govuk_jenkins::jobs::deploy_emergency_banner
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::deploy_emergency_banner(
  $clear_cdn_cache = false,
) {
  file { '/etc/jenkins_jobs/jobs/deploy_emergency_banner.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_emergency_banner.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

# == Class: govuk_jenkins::jobs::extract_app_performance
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::extract_app_performance (
  $app_domain_internal = hiera('app_domain_internal'),
  $cron_schedule = '0 6 1 * *',
) {
  file { '/etc/jenkins_jobs/jobs/extract_app_performance.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/extract_app_performance.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

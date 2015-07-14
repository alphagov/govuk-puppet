# == Class: govuk_jenkins::job::check_cdn_ip_ranges
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::check_cdn_ip_ranges {
  file { '/etc/jenkins_jobs/jobs/check_cdn_ip_ranges.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/check_cdn_ip_ranges.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

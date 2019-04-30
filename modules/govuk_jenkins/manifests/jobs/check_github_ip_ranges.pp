# == Class: govuk_jenkins::jobs::check_github_ip_ranges
#
# Create a jenkins-job-builder config file for checking that GitHub
# IP ranges are configured correctly.
#
class govuk_jenkins::jobs::check_github_ip_ranges {
  file { '/etc/jenkins_jobs/jobs/check_github_ip_ranges.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/check_github_ip_ranges.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

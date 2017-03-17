# == Class: govuk_jenkins::job::validate_published_dns
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters:
#  [*run_daily*]
#    Set to true to run this task every night and email on failures.
#
class govuk_jenkins::job::validate_published_dns (
  $run_daily = false,
){
  file { '/etc/jenkins_jobs/jobs/validate_published_dns.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/validate_published_dns.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

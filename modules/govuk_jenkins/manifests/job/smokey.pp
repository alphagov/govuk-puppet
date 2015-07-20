# == Class: govuk_jenkins::job::smokey
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::smokey (
  $efg_password = undef,
  $signon_email = undef,
  $smokey_bearer_token = undef,
  $smokey_rate_limit_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/smokey.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/smokey.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

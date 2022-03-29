# == Class: govuk_jenkins::jobs::smokey
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*environment*]
#   The environment which is running Smokey. Used to build the rake task.
#
class govuk_jenkins::jobs::smokey (
  $environment = 'production',
) {
  include govuk::apps::smokey

  file { '/etc/jenkins_jobs/jobs/smokey.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/smokey.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
    require => Class['govuk::apps::smokey'],
  }
}

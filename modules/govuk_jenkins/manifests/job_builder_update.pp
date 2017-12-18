# Class: govuk_jenkins::job_builder_update
#
# This class updates the jobs deployed to a Jenkins instance. It is
# extracted to its own wrapper class to allow each of the jobs to issue
# a `notify` against it without risk of side effects on other resources.
#
# == Parameters:
#
# [*jenkins_url*]
#   The URL to access Jenkins
#
class govuk_jenkins::job_builder_update (
  $jenkins_url = 'http://localhost:8080/',
) {

  include govuk_jenkins::job_builder

  exec { 'jenkins_jobs_update':
    command => '/usr/local/bin/jenkins-jobs update --delete-old /etc/jenkins_jobs/jobs/',
    onlyif  => "/usr/bin/curl ${jenkins_url}",
    require => Class['govuk_jenkins::job_builder'],
  }

}

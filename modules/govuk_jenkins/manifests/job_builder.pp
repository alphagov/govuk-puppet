# == Class: govuk_jenkins::job_builder
#
# This class uses the Python package `jenkins-job-builder` to create Jenkins jobs
# from YAML files.
#
# === Parameters:
#
# [*app_domain*]
#   The domain that is set across the platform.
#
# [*environment*]
#   Specify the environment ({production,staging,integration}). Required by some jobs.
#
# [*jenkins_user*]
#   A username of a user on Jenkins who has permission to create and modify jobs
#
# [*jenkins_api_token*]
#   The API token for $jenkins_user.
#
#   By default, in newer versions of Jenkins you will be unable to view another
#   users token. To get past this, temporarily set the following as an argument under
#   JAVA_ARGS in the init script and restart the Jenkins service:
#
#   "-Djenkins.security.ApiTokenProperty.showTokenToAdmins=true"
#
#   Ref: https://wiki.jenkins-ci.org/display/JENKINS/Features+controlled+by+system+properties
#
# [*jenkins_url*]
#   The URL to access Jenkins
#
# [*jobs*]
#   An Array of jobs which creates `govuk_jenkins::job` resources
#
class govuk_jenkins::job_builder (
  $app_domain = hiera('app_domain'),
  $environment = 'development',
  $jenkins_user = 'deploy',
  $jenkins_api_token = '',
  $jenkins_url = 'http://localhost:8080/',
  $jobs = [],
) {

  validate_array($jobs)

  package { 'jenkins-job-builder':
    ensure   => '1.3.0',
    provider => pip,
  }

  file { '/etc/jenkins_jobs':
    ensure  => directory,
    purge   => true,
    recurse => true,
  }

  file { '/etc/jenkins_jobs/jenkins_jobs.ini':
    ensure  => present,
    content => template('govuk_jenkins/jenkins_jobs.ini.erb'),
    require => File['/etc/jenkins_jobs'],
  }

  file { '/etc/jenkins_jobs/jobs':
    ensure  => directory,
    purge   => true,
    recurse => true,
  }

  include $jobs

  exec { 'jenkins_jobs_update':
    command => 'jenkins-jobs update --delete-old /etc/jenkins_jobs/jobs/',
    onlyif  => "curl ${jenkins_url}",
    require => [
      File['/etc/jenkins_jobs/jenkins_jobs.ini'],
      Package['jenkins-job-builder'],
    ],
  }

}

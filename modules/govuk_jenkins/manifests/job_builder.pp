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
#   Specify the environment ({production,staging,preview}). Required by some jobs.
#
# [*jenkins_user*]
#   A username of a user on Jenkins who has permission to create and modify jobs
#
# [*jenkins_api_token*]
#   The API token for $jenkins_user
#
# [*jenkins_url*]
#   The URL to access Jenkins
#
# [*manage_jobs*]
#   Whether jobs should be created and modified by jenkins-job-builder
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
  $manage_jobs = false,
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

  if $manage_jobs {
    file { '/etc/jenkins_jobs/jobs':
      ensure  => directory,
      purge   => true,
      recurse => true,
    }

    include $jobs

    exec { 'jenkins_jobs_update':
      command => 'jenkins-jobs update --delete-old /etc/jenkins_jobs/jobs/',
      require => [
        File['/etc/jenkins_jobs/jenkins_jobs.ini'],
        Package['jenkins-job-builder'],
      ],
    }
  }

}

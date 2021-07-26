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
  $environment_variables = $govuk_jenkins::environment_variables
  $smokey_task = "test:${environment}"
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')

  include govuk::apps::smokey

  $service_description = 'Smokey'

  file { '/etc/jenkins_jobs/jobs/smokey.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/smokey.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
    require => Class['govuk::apps::smokey'],
  }

  $job_url = "https://${deploy_jenkins_domain}/job/smokey/"

  @@icinga::passive_check { "smokey_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    action_url          => $job_url,
  }
}

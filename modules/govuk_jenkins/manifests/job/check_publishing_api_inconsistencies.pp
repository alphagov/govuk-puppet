# == Class: govuk_jenkins::job::check_publishing_api_inconsistencies
#
# Create a jenkins job to check for inconsistencies between the content-store and the router-api
#
#
# === Parameters:
#
class govuk_jenkins::job::check_publishing_api_inconsistencies {
  file { '/etc/jenkins_jobs/jobs/check_publishing_api_inconsistencies.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/check_publishing_api_inconsistencies.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

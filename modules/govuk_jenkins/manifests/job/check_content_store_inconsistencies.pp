# == Class: govuk_jenkins::job::check_content_store_inconsistencies
#
# Create a jenkins job to check for inconsistencies between the content-store and the router-api
#
#
# === Parameters:
#
class govuk_jenkins::job::check_content_store_inconsistencies {
  file { '/etc/jenkins_jobs/jobs/check_content_store_inconsistencies.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/check_content_store_inconsistencies.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

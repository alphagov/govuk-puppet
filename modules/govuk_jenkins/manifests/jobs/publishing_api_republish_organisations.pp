# == Class: govuk_jenkins::jobs::publishing_api_republish_organisations
#
# Create a jenkins job to periodically run rake for the following tasks:
# - represent_downstream:high_priority_document_type[:document_type]
#
# === Parameters:
#

class govuk_jenkins::jobs::publishing_api_republish_organisations{
  file { '/etc/jenkins_jobs/jobs/publishing_api_republish_organisations.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/publishing_api_republish_organisations.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

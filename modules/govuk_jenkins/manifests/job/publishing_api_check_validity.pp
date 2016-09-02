# == Class: govuk_jenkins::job::publishing_api_check_validity
#
# Create a jenkins job to check the validity of data within the Publishing API
#
#
# === Parameters:
#
class govuk_jenkins::job::publishing_api_check_validity {
  file { '/etc/jenkins_jobs/jobs/publishing_api_check_validity.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/publishing_api_check_validity.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

# == Class: govuk_jenkins::job::deploy_terraform_project
#
# [*projects*]
#   An array that contains the list of projects currently configured to deploy
#
class govuk_jenkins::job::deploy_terraform_project (
  $projects = [],
) {
  validate_array($projects)

  file { '/etc/jenkins_jobs/jobs/deploy_terraform_project.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_terraform_project.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

}

# == Class: govuk_jenkins::jobs::deploy_terraform_govuk_aws
#
class govuk_jenkins::jobs::deploy_terraform_govuk_aws {
  file { '/etc/jenkins_jobs/jobs/deploy_terraform_govuk_aws.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_terraform_govuk_aws.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  include ::govuk_jenkins::packages::terraform
  include ::govuk_jenkins::packages::sops
}

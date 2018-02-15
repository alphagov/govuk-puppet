# == Class: govuk_jenkins::jobs::deploy_terraform_project
#
# This deploys the old Terraform code. New code should be moved to govuk-aws.
#
# === Parameters
#
# [*aws_account_id*]
#   The account ID for Amazon Web Services, required by our Terraform code
#
# [*production_aws_account_id*]
#   The account ID for the production AWS account
#
class govuk_jenkins::jobs::deploy_terraform_project (
  $aws_account_id = '',
  $production_aws_account_id = '',
) {

  contain 'govuk_jenkins::packages::terraform'

  file { '/etc/jenkins_jobs/jobs/deploy_terraform_project.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_terraform_project.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

}

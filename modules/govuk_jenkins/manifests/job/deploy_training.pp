# == Class: govuk_jenkins::job::deploy_training
#
# Create the Jenkins job to deploy Training environment VM
# on AWS.
#
# === Parameters
#
# [*credential_id_govuk_ci_aws_access_key_id*]
#    Jenkins credential ID that identifies govuk-ci user aws_access_key_id
#    on Integration
#
# [*credential_id_govuk_ci_aws_secret_access_key*]
#    Jenkins credential ID that identifies govuk-ci user aws_secret_access_key
#    on Integration
#
# [*credential_id_gpg_key_duplicity_integration*]
#    Jenkins credential ID that identifies the Duplicity GPG key on Integration
#
# [*credential_id_gpg_key_duplicity_integration_passphrase*]
#    Jenkins credential ID that identifies the Duplicity GPG key passphrase on
#    Integration
#
# [*credential_id_govuk_training_ssh_key*]
#    Jenkins credential ID that identifies the govuk-training ssh key on Integration
#
class govuk_jenkins::job::deploy_training (
  $credential_id_govuk_ci_aws_access_key_id = undef,
  $credential_id_govuk_ci_aws_secret_access_key = undef,
  $credential_id_gpg_key_duplicity_integration = undef,
  $credential_id_gpg_key_duplicity_integration_passphrase = undef,
  $credential_id_govuk_training_ssh_key = undef,
) {

  contain '::govuk_jenkins::packages::terraform'

  file { '/etc/jenkins_jobs/jobs/deploy_training.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_training.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

}

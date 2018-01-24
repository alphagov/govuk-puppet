# == Class: govuk_jenkins::jobs::copy_attachments_from_staging_to_aws
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::copy_attachments_from_staging_to_aws (
  $app_domain = hiera('app_domain'),
) {
  file { '/etc/jenkins_jobs/jobs/copy_attachments_from_staging_to_aws.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/copy_attachments_from_staging_to_aws.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

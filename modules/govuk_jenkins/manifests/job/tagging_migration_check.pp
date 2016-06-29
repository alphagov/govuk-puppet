# == Class: govuk_jenkins::job::tagging_migration_check
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::tagging_migration_check (
  $app_domain = hiera('app_domain'),
) {

  file { '/etc/jenkins_jobs/jobs/tagging_migration_check.yaml':
    ensure  => absent,
  }
}

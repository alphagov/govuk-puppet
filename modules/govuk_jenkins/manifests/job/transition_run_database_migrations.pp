# == Class: govuk_jenkins::job::transition_run_database_migrations
#
# === Parameters
#
# [*auth_token*]
#   Token to allow this job to be triggered remotely
#
class govuk_jenkins::job::transition_run_database_migrations (
  $auth_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/transition_run_database_migrations.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/integration/transition_run_database_migrations.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

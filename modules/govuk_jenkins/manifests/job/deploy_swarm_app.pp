# == Class: govuk_jenkins::job::deploy_swarm_app
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*app_domain*]
#   The hostname where applications are served from
#
# [*auth_token*]
#   Token which will allow this job to be triggered remotely
#
class govuk_jenkins::job::deploy_swarm_app (
  $app_domain = undef,
  $auth_token = undef,
  $applications = undef,
) {
  if $::aws_migration {
    $aws_deploy = true
  }

  file { '/etc/jenkins_jobs/jobs/deploy_swarm_app.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_swarm_app.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

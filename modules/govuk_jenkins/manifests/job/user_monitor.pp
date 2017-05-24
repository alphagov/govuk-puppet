# == Class: govuk_jenkins::job::user_monitor
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*github_token*]
#   A GitHub access token with the `read:org` permissions
#
class govuk_jenkins::job::user_monitor (
  $github_token = undef,
  $app_domain = hiera('app_domain'),
) {

  $service_description = 'Check that correct users have access'

  file { '/etc/jenkins_jobs/jobs/user_monitor.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/user_monitor.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'];
  }

  @@icinga::passive_check {
    "user_monitor_${::hostname}":
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => 5400, # 90 minutes
      action_url          => "https://deploy.${app_domain}/job/user-monitor/",
      notes_url           => monitoring_docs_url(user-monitor);
  }
}

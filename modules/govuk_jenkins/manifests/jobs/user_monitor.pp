# == Class: govuk_jenkins::jobs::user_monitor
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*github_token*]
#   A GitHub access token with the `read:org` permissions
#
class govuk_jenkins::jobs::user_monitor (
  $github_token = undef,
  $sentry_auth_token = undef,
  $app_domain = hiera('app_domain'),
  $enable_icinga_check = false,
) {

  $service_description = 'Check that correct users have access'
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')

  file { '/etc/jenkins_jobs/jobs/user_monitor.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/user_monitor.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'];
  }

  $icinga_check_ensure = $enable_icinga_check ? {
    true  => 'present',
    false => 'absent'
  }

  @@icinga::passive_check {
    "user_monitor_${::hostname}":
      ensure              => $icinga_check_ensure,
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => 5400, # 90 minutes
      action_url          => "https://${deploy_jenkins_domain}/job/user-monitor/",
      notes_url           => monitoring_docs_url(user-monitor);
  }
}

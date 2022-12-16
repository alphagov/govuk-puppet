# == Class: govuk_jenkins::jobs::transition_import_dns
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::transition_import_dns {
  $slack_channel = '#govuk-publishing-platform'
  $slack_credential_id = 'slack-notification-token'
  $slack_team_domain = 'gds'
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')
  $slack_build_server_url = "https://${deploy_jenkins_domain}/"
  $environment = hiera('govuk_jenkins::jobs::deploy_app_downstream::deploy_environment')

  file { '/etc/jenkins_jobs/jobs/transition_import_dns.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/transition_import_dns.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

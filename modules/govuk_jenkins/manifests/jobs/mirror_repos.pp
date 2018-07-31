# == Class: govuk_jenkins::jobs::mirror_repos
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::mirror_repos (
  $app_domain = hiera('app_domain'),
) {

  $service_description = 'Check that GOV.UK Github repos are mirrored to AWS CodeCommit'

  file { '/etc/jenkins_jobs/jobs/mirror_repos.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/mirror_repos.yaml'),
    notify  => Exec['jenkins_jobs_update'];
  }

  @@icinga::passive_check {
    "user_monitor_${::hostname}":
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => 5400, # 90 minutes
      action_url          => "https://deploy.${app_domain}/job/mirror-repos/",
      notes_url           => 'https://github.com/alphagov/govuk-repo-mirror';
  }
}

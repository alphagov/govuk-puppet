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
    "mirror_repos_${::hostname}":
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => 7200, # 2 hours
      action_url          => 'https://ci.integration.publishing.service.gov.uk/job/Mirror_Repositories/',
      notes_url           => 'https://docs.publishing.service.gov.uk/manual/check-mirror-repos.html';
  }
}

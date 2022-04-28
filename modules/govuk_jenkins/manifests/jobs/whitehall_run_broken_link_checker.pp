# == Class: govuk_jenkins::jobs::whitehall_run_broken_link_checker
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::whitehall_run_broken_link_checker {
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')

  $service_description = 'Runs a rake task on Whitehall that generates a broken link report'
  $job_slug = 'whitehall_run_broken_link_checker'
  $job_url = "https://${deploy_jenkins_domain}/job/${job_slug}"

  file { '/etc/jenkins_jobs/jobs/whitehall_run_broken_link_checker.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/whitehall_run_broken_link_checker.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

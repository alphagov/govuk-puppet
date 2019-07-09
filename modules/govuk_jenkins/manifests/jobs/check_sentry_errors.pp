# == Class: govuk_jenkins::jobs::check_sentry_errors
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::check_sentry_errors (
  $sentry_auth_token = undef,
  $app_domain = hiera('app_domain'),
) {
  $check_name = 'check_sentry_errors'
  $service_description = 'Report the number of errors in Sentry to Graphite'
  $job_url = "https://deploy.${app_domain}/job/Check_Sentry_Errors/"

  file { '/etc/jenkins_jobs/jobs/check_sentry_errors.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/check_sentry_errors.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 104400,
    action_url          => $job_url,
  }
}

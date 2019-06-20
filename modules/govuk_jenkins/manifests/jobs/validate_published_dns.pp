# == Class: govuk_jenkins::jobs::validate_published_dns
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters:
#  [*run_daily*]
#    Set to true to run this task every night and email on failures.
#
class govuk_jenkins::jobs::validate_published_dns (
  $run_daily = false,
  $app_domain = hiera('app_domain'),
){
  file { '/etc/jenkins_jobs/jobs/validate_published_dns.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/validate_published_dns.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  $check_name = 'validate_published_dns'
  $service_description = 'Check that the published DNS records match those in the govuk-dns-config repo'
  $job_url = "https://deploy.${app_domain}/job/Validate_published_DNS/"

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 104400,
    action_url          => $job_url,
  }
}

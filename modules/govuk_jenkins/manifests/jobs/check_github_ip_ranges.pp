# == Class: govuk_jenkins::jobs::check_github_ip_ranges
#
# Create a jenkins-job-builder config file for checking that GitHub
# IP ranges are configured correctly.
#
class govuk_jenkins::jobs::check_github_ip_ranges(
  $app_domain = hiera('app_domain'),
) {
  file { '/etc/jenkins_jobs/jobs/check_github_ip_ranges.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/check_github_ip_ranges.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  $check_name = 'check_github_ip_ranges'
  $service_description = 'Compare the IP ranges that GitHub publishes against the ranges configured in govuk-provisioning'
  $job_url = "https://deploy.${app_domain}/job/Check_GitHub_IP_Ranges/"

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 104400,
    action_url          => $job_url,
  }
}

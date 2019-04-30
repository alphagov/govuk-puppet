# == Class: govuk_jenkins::jobs::enhanced_ecommerce_search_api
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::enhanced_ecommerce_search_api (
  $app_domain = hiera('app_domain'),
  $auth_username = undef,
  $auth_password = undef,
  $rate_limit_token = undef,
  $cron_schedule = '0 5 * * *'
) {

  $job_name = 'enhanced_ecommerce_search_api'
  $service_description = 'Export Enhanced Ecommerce data from Search API'
  $job_url = "https://deploy.${app_domain}/job/enhanced_ecommerce_search_api/"
  $target_application = 'search-api'

  file { '/etc/jenkins_jobs/jobs/enhanced_ecommerce_search_api.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/enhanced_ecommerce.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${job_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 104400,
    action_url          => $job_url,
    notes_url           => monitoring_docs_url(enhanced-ecommerce),
  }
}

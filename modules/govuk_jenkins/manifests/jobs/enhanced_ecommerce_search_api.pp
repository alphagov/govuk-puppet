# == Class: govuk_jenkins::jobs::enhanced_ecommerce_search_api
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::enhanced_ecommerce_search_api (
  $auth_username = undef,
  $auth_password = undef,
  $rate_limit_token = undef,
  $cron_schedule = undef
) {
  $job_name = 'enhanced_ecommerce_search_api'
  $service_description = 'Enhanced Ecommerce ETL from Search API to Google Analytics'
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')
  $job_url = "https://${deploy_jenkins_domain}/job/${job_name}/"
  $target_application = 'search-api'

  file { '/etc/jenkins_jobs/jobs/enhanced_ecommerce_search_api.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/enhanced_ecommerce.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  $check_ensure = $cron_schedule ? {
    undef   => absent,
    default => present,
  }

  @@icinga::passive_check { "${job_name}_${::hostname}":
    ensure              => $check_ensure,
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 104400,
    action_url          => $job_url,
    notes_url           => monitoring_docs_url(enhanced-ecommerce),
  }
}

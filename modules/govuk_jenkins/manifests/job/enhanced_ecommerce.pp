# == Class: govuk_jenkins::job::enhanced_ecommerce
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::enhanced_ecommerce (
  $app_domain = hiera('app_domain'),
  $auth_username = undef,
  $auth_password = undef,
  $rate_limit_token = undef,
  $cron_schedule = '0 5 * * *'
) {

  $job_name = 'enhanced_ecommerce'
  $service_description = 'Export Enhanced Ecommerce data'
  $job_url = "https://deploy.${app_domain}/job/enhanced_ecommerce/"

  file { '/etc/jenkins_jobs/jobs/enhanced_ecommerce.yaml':
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

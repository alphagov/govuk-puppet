# == Class: govuk_jenkins::jobs::search_generate_sitemaps
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::jobs::search_generate_sitemaps{
  $app_domain = hiera('app_domain')

  $service_description = 'Runs a rake task on Search API that generates the sitemap files'
  $job_slug = 'search_generate_sitemaps'
  $job_url = "https://deploy.${app_domain}/job/${job_slug}"

  file { '/etc/jenkins_jobs/jobs/search_generate_sitemaps.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/search_generate_sitemaps.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${job_slug}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 129600,
    action_url          => $job_url,
  }
}

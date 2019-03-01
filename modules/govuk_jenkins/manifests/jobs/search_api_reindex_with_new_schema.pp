# == Class: govuk_jenkins::jobs::search_api_reindex_with_new_schema
#
# Test rebuilding the search indexes and reindexing all content
#
class govuk_jenkins::jobs::search_api_reindex_with_new_schema (
  $app_domain = hiera('app_domain'),
  $icinga_check_enabled = false,
  $cron_schedule = undef,
) {

  $check_name = 'search-api-reindex-with-new-schema'
  $service_description = 'Rebuild new Search API indexes with up to date settings and mappings and reindex all content from the existing indexes.'
  $job_name = 'search_api_reindex_with_new_schema'
  $job_display_name = 'Search API reindex with new schema'
  $job_url = "https://deploy.${app_domain}/job/search-reindex-with-new-schema/"
  $target_application = 'search-api'

  file { '/etc/jenkins_jobs/jobs/search_api_reindex_with_new_schema.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/search_reindex_with_new_schema.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  if ($icinga_check_enabled) {
    @@icinga::passive_check { "${check_name}_${::hostname}":
      service_description => $service_description,
      host_name           => $::fqdn,
      freshness_threshold => 619200,
      action_url          => $job_url,
      notes_url           => monitoring_docs_url(search-reindex-failed),
    }
  }
}

# == Class: govuk_jenkins::jobs::search-reindex-with-new-schema
#
# Test rebuilding the search indexes and reindexing all content
#
class govuk_jenkins::jobs::search_reindex_with_new_schema (
  $app_domain = hiera('app_domain'),
  $icinga_check_enabled = false,
  $cron_schedule = undef,
) {

  $check_name = 'search-reindex-with-new-schema'
  $service_description = 'Rebuild new search indexes with up to date settings and mappings and reindex all content from the existing indexes.'
  $job_url = "https://deploy.${app_domain}/job/search-reindex-with-new-schema/"

  file { '/etc/jenkins_jobs/jobs/search_reindex_with_new_schema.yaml':
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

# == Class: govuk_jenkins::job::prune_elasticsearch_snapshots
#
# Delete old Elasticsearch snapshots
#
class govuk_jenkins::job::prune_elasticsearch_snapshots (
    $app_domain = hiera('app_domain'),
) {

  $check_name = 'prune_elasticsearch_snapshots'
  $service_description = 'Prune Elasticsearch snapshots'
  $job_url = "https://deploy.${app_domain}/job/prune_elasticsearch_snapshots"

  file { '/etc/jenkins_jobs/jobs/prune_elasticsearch_snapshots.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/prune_elasticsearch_snapshots.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  $threshold_secs = 25 * 60 * 60

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => $threshold_secs,
  }
}

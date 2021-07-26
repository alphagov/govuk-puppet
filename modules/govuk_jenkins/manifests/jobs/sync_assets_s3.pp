# == Class: govuk_jenkins::jobs::sync_assets_s3
#
# Sync assets from Production to Staging/Integration. Intended to run only from
# Production.
#
class govuk_jenkins::jobs::sync_assets_s3 {
  $check_name = 'sync_assets_s3_from_prod_to_staging_and_integration'
  $deploy_jenkins_domain = hiera('deploy_jenkins_domain')
  $job_url = "https://${deploy_jenkins_domain}/job/sync_assets_s3/"
  $service_description = 'Sync assets in S3 from Production to Staging and Integration'

  file { '/etc/jenkins_jobs/jobs/sync_assets_s3.yaml':
    content => template('govuk_jenkins/jobs/sync_assets_s3.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 115200,
    action_url          => $job_url,
    notes_url           => monitoring_docs_url(data-sync),
  }
}

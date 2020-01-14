# == Class: govuk_jenkins::jobs::transition_import_hits
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*s3_bucket*]
#   The S3 bucket to pull hits from
#
class govuk_jenkins::jobs::transition_import_hits(
  $s3_bucket = '',
  $app_domain = hiera('app_domain'),
) {
  $service_description = 'Import daily hits into Transition'

  file { '/etc/jenkins_jobs/jobs/transition_import_hits.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/transition_import_hits.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  $check_name = 'transition-import-hits'

  $job_url = "https://deploy.blue.${::aws_environment}.govuk.digital/job/transition_import_hits/"

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 25 * 60 * 60, # one day plus one hour
    action_url          => $job_url,
  }
}

# == Class: govuk_jenkins::jobs::deploy_dns
#
# Create the Jenkins job to deploy DNS records.
# Target platforms are:
#      AWS Route 53
#      Google Cloud DNS
#
# === Parameters
#
# [*dyn_zone_id*]
#   ID of the Dyn DNS zone to upload the DNS records to.
#
# [*gce_project_id*]
#   The name of the Google Compute Engine project that contains the resources you want to interact with.
#
# [*gce_credential_id*]
#   Jenkins credential ID that stores the Gcloud account.
#
# [*zones*]
#   An array of zones to deploy.
#
class govuk_jenkins::jobs::deploy_dns (
  $dyn_zone_id = undef,
  $gce_project_id = undef,
  $gce_credential_id = undef,
  $zones = [],
) {

  validate_array($zones)

  contain '::govuk_jenkins::packages::terraform'

  file { '/etc/jenkins_jobs/jobs/deploy_dns.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_dns.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

}

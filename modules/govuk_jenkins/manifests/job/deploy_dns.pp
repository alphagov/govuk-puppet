# == Class: govuk_jenkins::job::deploy_dns
#
# Create the Jenkins job to deploy DNS records.
#
# === Parameters
#
# [*dyn_zone_id*]
#   ID of the Dyn DNS zone to upload the DNS records to.
#
# [*route53_zone_id*]
#   ID of the route53 DNS zone to upload to
#
# [*dyn_customer_name*]
#   Customer account to use for Dyn (not to be confused with the Dyn user name)
#
# [*gce_zone_id*]
#   The zone ID to deploy to
#
# [*gce_project_id*]
#   The ID or name of the project
#
# [*gce_private_key*]
#   The private key of the credentials to authenticate with
#
# [*gce_client_name*]
#   The client name for the credentials you're using to authenticate
#
# [*gce_credentials*]
#   Location of the Google credentials file.
#
# [*gce_region*]
#   The region of the zone you're deploying to.
#
class govuk_jenkins::job::deploy_dns (
    $dyn_zone_id,
    $route53_zone_id,
    $dyn_customer_name,
    $gce_zone_id,
    $gce_project_id,
    $gce_private_key,
    $gce_client_name,
    $gce_credentials = '/var/lib/jenkins/gce_credentials.json',
    $gce_region= 'europe-west1-d',
) {
  file { '/etc/jenkins_jobs/jobs/deploy_dns.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_dns.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  file { $gce_credentials:
    ensure  => present,
    owner   => 'jenkins',
    group   => 'jenkins',
    content => template('govuk_jenkins/gce_credentials.json.erb'),
  }
}

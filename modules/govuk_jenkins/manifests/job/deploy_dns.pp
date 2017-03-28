# == Class: govuk_jenkins::job::deploy_dns
#
# Create the Jenkins job to deploy DNS records.
# Target platforms are:
#      AWS Route 53
#      Dyn
#      Google Cloud DNS
#
# === Parameters
#
# [*dyn_customer_name*]
#    Customer account to use for Dyn (not to be confused with the Dyn user name)
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
# [*route53_zone_id*]
#   ID of the route53 DNS zone to upload to
#
class govuk_jenkins::job::deploy_dns (
  $dyn_customer_name = undef,
  $dyn_zone_id = undef,
  $gce_project_id = undef,
  $gce_credential_id = undef,
  $route53_zone_id = undef,
) {

  contain '::govuk_jenkins::packages::terraform'

  file { '/etc/jenkins_jobs/jobs/deploy_dns.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_dns.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

}

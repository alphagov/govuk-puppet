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
#    Customer account to use for Dyn (not to be confused with the Dyn user name)
#
class govuk_jenkins::job::deploy_dns (
    $dyn_zone_id,
    $route53_zone_id,
    $dyn_customer_name,
) {
  file { '/etc/jenkins_jobs/jobs/deploy_dns.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_dns.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

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
# [*credentials_file_path*]
#   Auth file that allows a service account to interact with the Google Compute Cloud API programmatically.
#
# [*dyn_customer_name*]
#    Customer account to use for Dyn (not to be confused with the Dyn user name)
#
# [*dyn_zone_id*]
#   ID of the Dyn DNS zone to upload the DNS records to.
#
# [*gce_client_id*]
#   Unique hash ID of the service account.
#
# [*gce_client_name*]
#   The username of the service account.
#
# [*gce_private_key*]
#   The service account's private key.
#
# [*gce_private_key_id*]
#   Unique hash ID of the private key being used.
#
# [*gce_project_id*]
#   The name of the Google Compute Engine project that contains the resources you want to interact with.
#
# [*route53_zone_id*]
#   ID of the route53 DNS zone to upload to
#
class govuk_jenkins::job::deploy_dns (
  $credentials_file_path = '/etc/gce/gce_credentials.json',
  $dyn_customer_name = undef,
  $dyn_zone_id = undef,
  $gce_client_id = undef,
  $gce_client_name = undef,
  $gce_private_key = undef,
  $gce_private_key_id = undef,
  $gce_project_id = undef,
  $route53_zone_id = undef,
) {

  file { '/etc/jenkins_jobs/jobs/deploy_dns.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_dns.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  file { '/etc/gce':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { $credentials_file_path:
    ensure  => file,
    owner   => 'jenkins',
    group   => 'root',
    mode    => '0600',
    content => template('govuk_jenkins/gce_credentials.json.erb'),
    require => File['/etc/gce'],
  }

  ensure_packages(['terraform'])

}

# == Class: govuk_jenkins::jobs::bouncer_cdn
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*cdn_password_encrypted*]
#   Password for the `$cdn_username` account. This password
#   must be encrypted by Jenkins before passing it in as a
#   parameter. You can do this by taking the plaintext password,
#   adding it as a password parameter in Jenkins and taking the
#   result from the `config.xml` file.
#
# [*cdn_service_id*]
#   CDN service ID.
#
# [*cdn_username*]
#   Username for an account with our CDN provider.
#
class govuk_jenkins::jobs::bouncer_cdn (
  $cdn_password_encrypted = undef,
  $cdn_service_id = undef,
  $cdn_username = undef,
  $app_domain = hiera('app_domain'),
) {

  $check_name = 'bouncer-cdn-configuration'
  $service_description = 'Configure Bouncer CDN service with transitioning sites'
  $job_url = "https://deploy.${app_domain}/job/Bouncer_CDN/"

  file { '/etc/jenkins_jobs/jobs/bouncer_cdn.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/bouncer_cdn.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    freshness_threshold => 104400,
    action_url          => $job_url,
  }
}

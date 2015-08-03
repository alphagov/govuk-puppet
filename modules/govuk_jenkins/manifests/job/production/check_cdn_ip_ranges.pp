# == Class: govuk_jenkins::job::production::check_cdn_ip_ranges
#
# Create a jenkins-job-builder config file for checking that CDN
# IP ranges are configured correctly.
#
# === Parameters
#
# [*cdn_username*]
#   Username for an account with our CDN provider.
#
# [*cdn_password_encrypted*]
#   Password for the `$cdn_username` account. This password
#   must be encrypted by Jenkins before passing it in as a
#   parameter. You can do this by taking the plaintext password,
#   adding it as a password parameter in Jenkins and taking the
#   result from the `config.xml` file.
#
class govuk_jenkins::job::production::check_cdn_ip_ranges (
  $cdn_username = undef,
  $cdn_password_encrypted = undef,
) {
  file { '/etc/jenkins_jobs/jobs/check_cdn_ip_ranges.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production/check_cdn_ip_ranges.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}

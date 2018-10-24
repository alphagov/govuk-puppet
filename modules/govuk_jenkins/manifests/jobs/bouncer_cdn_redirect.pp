# == Class: govuk_jenkins::jobs::bouncer_cdn_redirect
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
class govuk_jenkins::jobs::bouncer_cdn_redirect {

  file { '/etc/jenkins_jobs/jobs/bouncer_cdn.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/bouncer_cdn_redirect.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

}

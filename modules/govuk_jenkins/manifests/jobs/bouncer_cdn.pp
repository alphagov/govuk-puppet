# == Class: govuk_jenkins::jobs::bouncer_cdn
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*api_key*]
#   API key for our account. This must be encrypted by Jenkins before passing
#   it in as a parameter. You can do this by taking the plaintext password,
#   adding it as a password parameter in Jenkins and taking the
#   result from the `config.xml` file.
#
# [*service_id*]
#   CDN service ID.
#
class govuk_jenkins::jobs::bouncer_cdn (
  $api_key = undef,
  $service_id = undef,
  $app_domain = hiera('app_domain'),
) {
  $service_description = 'Configure Bouncer CDN service with transitioning sites'

  file { '/etc/jenkins_jobs/jobs/bouncer_cdn.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/bouncer_cdn.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

  $check_name = 'bouncer-cdn-configuration'

  # FIXME: go back to using $app_domain once we have a single Icinga instance in AWS
  $job_url = "https://deploy.${::aws_environment}.govuk.digital/job/Bouncer_CDN/"

  @@icinga::passive_check { "${check_name}_${::hostname}":
    service_description => $service_description,
    host_name           => $::fqdn,
    action_url          => $job_url,
  }
}
